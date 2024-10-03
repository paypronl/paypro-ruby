# frozen_string_literal: true

module PayPro
  class ApiClient
    def initialize(config)
      @config = config
    end

    # rubocop:disable Metrics/ParameterLists
    def request(method:, uri:, params: {}, headers: {}, body: nil, options: {})
      options = merge_options(options)

      check_api_key!(options)

      response = connection(options).public_send(method, uri) do |req|
        req.params = params
        req.headers = headers.merge(request_headers(options[:api_key]))
        req.body = body
      end

      default_params = {
        http_status: response.status,
        http_body: response.body,
        http_headers: response.headers
      }

      if response.status >= 400
        handle_error_response(response, **default_params)
      else
        handle_response(response, **default_params)
      end
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError
      raise PayPro::ConnectionError.new(
        message: 'Failed to make a connection to the PayPro API. ' \
                 'This could indicate a DNS issue or because you have no internet connection.'
      )
    rescue Faraday::SSLError
      raise PayPro::ConnectionError.new(
        message: 'Failed to create a secure connection with the PayPro API. ' \
                 'Please check your OpenSSL version supports TLS 1.2+.'
      )
    rescue Faraday::Error => e
      raise PayPro::Error.new(message: "Failed to connect to the PayPro API. Message: #{e.message}")
    end
    # rubocop:enable Metrics/ParameterLists

    private

    def check_api_key!(options)
      return unless options[:api_key].nil?

      raise AuthenticationError.new(
        message: 'API key not set. ' \
                 'Make sure to set the API key with "PayPro.api_key = <API_KEY>". ' \
                 'You can find your API key in the PayPro dashboard at "https://app.paypro.nl/developers/api-keys".'
      )
    end

    def handle_response(response, **default_params)
      PayPro::Response.from_response(response)
    rescue JSON::ParserError
      raise PayPro::Error.new(
        message: 'Invalid response from API. ' \
                 'The JSON returned in the body is not valid.',
        **default_params
      )
    end

    def handle_error_response(response, **default_params)
      pay_pro_response = PayPro::Response.from_response(response)

      case pay_pro_response.status
      when 401
        raise AuthenticationError.new(
          message: 'Invalid API key supplied. ' \
                   'Make sure to set a correct API key without any whitespace around it. ' \
                   'You can find your API key in the PayPro dashboard at "https://app.paypro.nl/developers/api-keys".',
          **default_params
        )
      when 404
        raise ResourceNotFoundError.new(message: 'Resource not found', **default_params)
      when 422
        raise ValidationError.new(
          param: pay_pro_response.data['error']['param'],
          message: pay_pro_response.data['error']['message'],
          code: pay_pro_response.data['error']['type'],
          **default_params
        )
      end
    rescue JSON::ParserError
      raise PayPro::Error.new(
        message: 'Invalid response from API. ' \
                 'The JSON returned in the body is not valid.',
        **default_params
      )
    end

    def request_headers(api_key)
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_key}",
        'User-Agent' => user_agent
      }
    end

    def user_agent
      @user_agent ||= "PayPro #{PayPro::VERSION} / Ruby #{RUBY_VERSION} / OpenSSL #{OpenSSL::VERSION}"
    end

    def connection(options)
      Faraday.new(
        request: {
          open_timeout: @config.timeout,
          timeout: @config.timeout
        },
        ssl: {
          ca_path: @config.ca_bundle_path,
          verify: @config.verify_ssl
        },
        url: options[:api_url]
      )
    end

    def merge_options(options)
      {
        api_key: options[:api_key] || @config.api_key,
        api_url: options[:api_url] || @config.api_url
      }
    end
  end
end

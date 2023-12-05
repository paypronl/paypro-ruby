# frozen_string_literal: true

module PayPro
  class Client
    attr_reader :config

    def self.default_client
      Thread.current[:paypro_ruby_client] ||= new
    end

    def initialize(config = {})
      @config = case config
                when Hash
                  PayPro.config.merge(config)
                when PayPro::Config
                  config
                else
                  raise ArgumentError, "Invalid argument: #{config}"
                end

      @connection = Faraday.new(
        request: {
          open_timeout: @config.timeout,
          timeout: @config.timeout
        },
        url: @config.api_url
      )
    end

    def request(method:, uri:, params: {}, headers: {}, body: nil)
      check_api_key!

      response = @connection.public_send(method, uri) do |req|
        req.params = params
        req.headers = headers.merge(request_headers(@config.api_key))
        req.body = body
      end

      if response.status >= 400
        handle_error_response(response)
      else
        handle_response(response)
      end
    rescue Faraday::ConnectionFailed, Faraday::SSLError, Faraday::TimeoutError => e
      raise PayPro::ConnectionError, e.message
    rescue Faraday::Error => e
      raise PayPro::Error, e.message
    end

    private

    def check_api_key!
      return unless @config.api_key.nil?

      raise AuthenticationError.new(
        message: 'API key not set. ' \
                 'Make sure to set the API key with "PayPro.api_key = <API_KEY>". ' \
                 'You can find your API key in the PayPro dashboard at "https://app.paypro.nl/developers/api-keys".'
      )
    end

    def handle_response(response)
      PayPro::Response.from_response(response)
    rescue JSON::ParserError
      raise PayPro::Error.new(
        message: 'Invalid response from API',
        **default_params
      )
    end

    def handle_error_response(response)
      pay_pro_response = PayPro::Response.from_response(response)

      default_params = {
        http_status: response.status,
        http_body: response.body,
        http_headers: response.headers
      }

      case pay_pro_response.status

      when 401
        raise AuthenticationError.new(message: 'Invalid API key supplied', **default_params)
      when 404
        raise ResourceNotFoundError.new(message: 'Resource not found', **default_params)
      when 422
        raise ValidationError.new(
          message: pay_pro_response.data['error']['message'],
          param: pay_pro_response.data['error']['param'],
          code: pay_pro_response.data['error']['type'],
          **default_params
        )
      end
    rescue JSON::ParserError
      raise PayPro::Error.new(
        message: 'Invalid response from API',
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
  end
end

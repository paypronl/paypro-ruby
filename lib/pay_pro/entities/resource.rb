# frozen_string_literal: true

module PayPro
  class Resource < Entity
    def self.resource_url
      "/#{self::RESOURCE_PATH}"
    end

    def self.get(id)
      api_request(method: 'get', uri: "#{resource_url}/#{CGI.escape(id)}")
    end

    def self.api_request(method:, uri:, params: {}, body: nil)
      client = PayPro::Client.default_client

      response = client.request(method: method, uri: uri, params: params, body: body)
      Util.to_entity(response.data, params: params)
    end

    def resource_url
      "#{self.class.resource_url}/#{CGI.escape(id)}"
    end
  end
end

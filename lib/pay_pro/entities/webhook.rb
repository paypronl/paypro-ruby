# frozen_string_literal: true

module PayPro
  class Webhook < Entity
    def self.get(id)
      api_request(method: 'get', uri: "/webhooks/#{CGI.escape(id)}")
    end

    def self.list(**kwargs)
      api_request(method: 'get', uri: '/webhooks', params: kwargs)
    end

    def self.create(**body)
      api_request(method: 'post', uri: '/webhooks', body: body.to_json)
    end

    def update(**body)
      self.class.api_request(method: 'patch', uri: "/webhooks/#{CGI.escape(id)}", body: body.to_json)
    end

    def delete
      self.class.api_request(method: 'delete', uri: "/webhooks/#{CGI.escape(id)}")
    end
  end
end

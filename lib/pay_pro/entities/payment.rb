# frozen_string_literal: true

module PayPro
  class Payment < Entity
    def self.get(id)
      api_request(method: 'get', uri: "/payments/#{CGI.escape(id)}")
    end

    def self.list(**kwargs)
      api_request(method: 'get', uri: '/payments', params: kwargs)
    end

    def self.create(**body)
      api_request(method: 'post', uri: '/payments', body: body.to_json)
    end

    def cancel
      self.class.api_request(method: 'delete', uri: "/payments/#{CGI.escape(id)}")
    end

    def refund(**body)
      self.class.api_request(method: 'post', uri: "/payments/#{CGI.escape(id)}/refunds", body: body.to_json)
    end

    def refunds(**kwargs)
      self.class.api_request(method: 'get', uri: "/payments/#{CGI.escape(id)}/refunds", params: kwargs)
    end

    def chargebacks(**kwargs)
      self.class.api_request(method: 'get', uri: "/payments/#{CGI.escape(id)}/chargebacks", params: kwargs)
    end
  end
end

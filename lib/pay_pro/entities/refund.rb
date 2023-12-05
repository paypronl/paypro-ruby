# frozen_string_literal: true

module PayPro
  class Refund < Entity
    def self.get(id)
      api_request(method: 'get', uri: "/refunds/#{CGI.escape(id)}")
    end

    def self.list(**kwargs)
      api_request(method: 'get', uri: '/refunds', params: kwargs)
    end

    def cancel
      self.class.api_request(method: 'delete', uri: "/refunds/#{CGI.escape(id)}")
    end
  end
end

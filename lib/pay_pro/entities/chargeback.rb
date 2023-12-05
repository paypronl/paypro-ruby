# frozen_string_literal: true

module PayPro
  class Chargeback < Entity
    def self.get(id)
      api_request(method: 'get', uri: "/chargebacks/#{CGI.escape(id)}")
    end

    def self.list(**kwargs)
      api_request(method: 'get', uri: '/chargebacks', params: kwargs)
    end
  end
end

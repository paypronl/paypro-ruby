# frozen_string_literal: true

module PayPro
  class SubscriptionPeriod < Entity
    def self.get(id)
      api_request(method: 'get', uri: "/subscription_periods/#{CGI.escape(id)}")
    end

    def self.list(**kwargs)
      api_request(method: 'get', uri: '/subscription_periods', params: kwargs)
    end

    def payments(**kwargs)
      api_request(method: 'get', uri: "/subscription_periods/#{CGI.escape(id)}/payments", params: kwargs)
    end
  end
end

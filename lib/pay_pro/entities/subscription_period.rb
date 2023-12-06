# frozen_string_literal: true

module PayPro
  class SubscriptionPeriod < Resource
    include PayPro::Operations::Listable

    RESOURCE_PATH = 'subscription_periods'

    def payments(**kwargs)
      api_request(method: 'get', uri: "#{resource_url}/payments", params: kwargs)
    end
  end
end

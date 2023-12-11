# frozen_string_literal: true

module PayPro
  class SubscriptionPeriod < Resource
    include PayPro::Operations::Listable

    RESOURCE_PATH = 'subscription_periods'
  end
end

# frozen_string_literal: true

module PayPro
  module Endpoints
    class SubscriptionPeriods < Endpoint
      include PayPro::Operations::Getable

      def resource_path
        'subscription_periods'
      end
    end
  end
end

# frozen_string_literal: true

module PayPro
  module Endpoints
    class InstallmentPlanPeriods < Endpoint
      include PayPro::Operations::Getable

      def resource_path
        'installment_plan_periods'
      end
    end
  end
end

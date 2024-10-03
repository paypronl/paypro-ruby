# frozen_string_literal: true

module PayPro
  module Endpoints
    class InstallmentPlans < Endpoint
      include PayPro::Operations::Creatable
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'installment_plans'
      end
    end
  end
end

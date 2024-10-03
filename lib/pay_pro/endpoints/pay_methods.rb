# frozen_string_literal: true

module PayPro
  module Endpoints
    class PayMethods < Endpoint
      include PayPro::Operations::Listable

      def resource_path
        'pay_methods'
      end
    end
  end
end

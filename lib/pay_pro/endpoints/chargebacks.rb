# frozen_string_literal: true

module PayPro
  module Endpoints
    class Chargebacks < Endpoint
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'chargebacks'
      end
    end
  end
end

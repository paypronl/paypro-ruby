# frozen_string_literal: true

module PayPro
  module Endpoints
    class Payments < Endpoint
      include PayPro::Operations::Creatable
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'payments'
      end
    end
  end
end

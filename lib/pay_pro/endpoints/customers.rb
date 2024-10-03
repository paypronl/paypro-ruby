# frozen_string_literal: true

module PayPro
  module Endpoints
    class Customers < Endpoint
      include PayPro::Operations::Creatable
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'customers'
      end
    end
  end
end

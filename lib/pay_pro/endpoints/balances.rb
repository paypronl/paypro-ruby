# frozen_string_literal: true

module PayPro
  module Endpoints
    class Balances < Endpoint
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'balances'
      end
    end
  end
end

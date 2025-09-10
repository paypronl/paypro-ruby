# frozen_string_literal: true

module PayPro
  module Endpoints
    class Payouts < Endpoint
      include PayPro::Operations::Creatable
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'payouts'
      end
    end
  end
end

# frozen_string_literal: true

module PayPro
  module Endpoints
    class Subscriptions < Endpoint
      include PayPro::Operations::Creatable
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'subscriptions'
      end
    end
  end
end

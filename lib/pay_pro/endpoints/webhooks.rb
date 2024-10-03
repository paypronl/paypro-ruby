# frozen_string_literal: true

module PayPro
  module Endpoints
    class Webhooks < Endpoint
      include PayPro::Operations::Creatable
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'webhooks'
      end
    end
  end
end

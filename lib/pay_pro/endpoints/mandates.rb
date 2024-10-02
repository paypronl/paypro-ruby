# frozen_string_literal: true

module PayPro
  module Endpoints
    class Mandates < Endpoint
      include PayPro::Operations::Creatable
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'mandates'
      end
    end
  end
end

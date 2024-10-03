# frozen_string_literal: true

module PayPro
  module Endpoints
    class Events < Endpoint
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'events'
      end
    end
  end
end

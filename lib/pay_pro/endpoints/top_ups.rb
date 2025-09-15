# frozen_string_literal: true

module PayPro
  module Endpoints
    class TopUps < Endpoint
      include PayPro::Operations::Creatable
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'top_ups'
      end
    end
  end
end

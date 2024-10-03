# frozen_string_literal: true

module PayPro
  module Endpoints
    class Refunds < Endpoint
      include PayPro::Operations::Getable
      include PayPro::Operations::Listable

      def resource_path
        'refunds'
      end
    end
  end
end

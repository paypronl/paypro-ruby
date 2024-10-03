# frozen_string_literal: true

module PayPro
  module Operations
    module Deletable
      def delete(**options)
        api_request(method: 'delete', uri: resource_url, options: options)
      end
    end
  end
end

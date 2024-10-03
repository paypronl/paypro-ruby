# frozen_string_literal: true

module PayPro
  module Operations
    module Listable
      def list(params = {}, **options)
        api_request(method: 'get', uri: resource_url, params: params, options: options)
      end
    end
  end
end

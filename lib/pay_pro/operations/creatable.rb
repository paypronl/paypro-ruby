# frozen_string_literal: true

module PayPro
  module Operations
    module Creatable
      def create(body = {}, **options)
        api_request(method: 'post', uri: resource_url, body: body.to_json, options: options)
      end
    end
  end
end

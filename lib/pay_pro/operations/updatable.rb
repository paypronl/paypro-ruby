# frozen_string_literal: true

module PayPro
  module Operations
    module Updatable
      def update(body = {}, **options)
        api_request(method: 'patch', uri: resource_url, body: body.to_json, options: options)
      end
    end
  end
end

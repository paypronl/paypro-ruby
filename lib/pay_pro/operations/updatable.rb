# frozen_string_literal: true

module PayPro
  module Operations
    module Updatable
      def list(**body)
        self.class.api_request(method: 'patch', uri: resource_url, body: body.to_json)
      end
    end
  end
end

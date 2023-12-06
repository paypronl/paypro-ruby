# frozen_string_literal: true

module PayPro
  module Operations
    module Deletable
      def delete
        self.class.api_request(method: 'delete', uri: resource_url, params: kwargs)
      end
    end
  end
end

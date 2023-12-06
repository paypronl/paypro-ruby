# frozen_string_literal: true

module PayPro
  module Operations
    module Creatable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def create(**body)
          api_request(method: 'post', uri: resource_url, body: body.to_json)
        end
      end
    end
  end
end

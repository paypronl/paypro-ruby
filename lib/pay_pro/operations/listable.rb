# frozen_string_literal: true

module PayPro
  module Operations
    module Listable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def list(**kwargs)
          api_request(method: 'get', uri: resource_url, params: kwargs)
        end
      end
    end
  end
end

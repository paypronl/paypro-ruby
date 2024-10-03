# frozen_string_literal: true

module PayPro
  module Operations
    module Getable
      def get(id, **options)
        api_request(method: 'get', uri: "#{resource_url}/#{CGI.escape(id)}", options: options)
      end
    end
  end
end

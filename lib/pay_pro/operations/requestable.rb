# frozen_string_literal: true

module PayPro
  module Operations
    module Requestable
      def api_request(method:, uri:, params: {}, body: nil, options: {})
        response = api_client.request(method: method, uri: uri, params: params, body: body, options: options)
        Util.to_entity(response.data, params: params, api_client: api_client)
      end
    end
  end
end

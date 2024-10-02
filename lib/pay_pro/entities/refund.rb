# frozen_string_literal: true

module PayPro
  class Refund < Resource
    RESOURCE_PATH = 'refunds'

    def cancel(**options)
      api_request(method: 'delete', uri: resource_url, options: options)
    end
  end
end

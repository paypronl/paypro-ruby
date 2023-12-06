# frozen_string_literal: true

module PayPro
  class Refund < Resource
    include PayPro::Operations::Listable

    RESOURCE_PATH = 'refunds'

    def cancel
      self.class.api_request(method: 'delete', uri: resource_url)
    end
  end
end

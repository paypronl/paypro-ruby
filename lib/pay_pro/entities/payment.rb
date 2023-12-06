# frozen_string_literal: true

module PayPro
  class Payment < Resource
    include PayPro::Operations::Creatable
    include PayPro::Operations::Listable

    RESOURCE_PATH = 'payments'

    def cancel
      self.class.api_request(method: 'delete', uri: resource_url)
    end

    def refund(**body)
      self.class.api_request(method: 'post', uri: "#{resource_url}/refunds", body: body.to_json)
    end

    def refunds(**kwargs)
      self.class.api_request(method: 'get', uri: "#{resource_url}/refunds", params: kwargs)
    end

    def chargebacks(**kwargs)
      self.class.api_request(method: 'get', uri: "#{resource_url}/chargebacks", params: kwargs)
    end
  end
end

# frozen_string_literal: true

module PayPro
  class Payment < Resource
    RESOURCE_PATH = 'payments'

    def cancel(**options)
      api_request(method: 'delete', uri: resource_url, options: options)
    end

    def refund(body = {}, **options)
      api_request(method: 'post', uri: "#{resource_url}/refunds", body: body.to_json, options: options)
    end

    def refunds(params = {}, **options)
      api_request(method: 'get', uri: "#{resource_url}/refunds", params: params, options: options)
    end

    def chargebacks(params = {}, **options)
      api_request(method: 'get', uri: "#{resource_url}/chargebacks", params: params, options: options)
    end
  end
end

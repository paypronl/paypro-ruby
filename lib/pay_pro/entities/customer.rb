# frozen_string_literal: true

module PayPro
  class Customer < Resource
    include PayPro::Operations::Updatable

    RESOURCE_PATH = 'customers'

    def mandates(**options)
      api_request(
        method: 'get',
        uri: "#{resource_url}/mandates",
        options: options
      )
    end

    def subscriptions(**options)
      api_request(
        method: 'get',
        uri: "#{resource_url}/subscriptions",
        options: options
      )
    end
  end
end

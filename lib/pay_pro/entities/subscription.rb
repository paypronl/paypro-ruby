# frozen_string_literal: true

module PayPro
  class Subscription < Resource
    include PayPro::Operations::Updatable

    RESOURCE_PATH = 'subscriptions'

    def cancel(**options)
      api_request(method: 'delete', uri: resource_url, options: options)
    end

    def pause(**options)
      api_request(method: 'post', uri: "#{resource_url}/pause", options: options)
    end

    def resume(**options)
      api_request(method: 'post', uri: "#{resource_url}/resume", options: options)
    end

    def subscription_periods(**options)
      api_request(
        method: 'get',
        uri: "#{resource_url}/subscription_periods",
        options: options
      )
    end

    def create_subscription_period(body = {}, **options)
      api_request(
        method: 'post',
        uri: "#{resource_url}/subscription_periods",
        body: body.to_json,
        options: options
      )
    end
  end
end

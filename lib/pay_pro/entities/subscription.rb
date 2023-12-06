# frozen_string_literal: true

module PayPro
  class Subscription < Resource
    include PayPro::Operations::Creatable
    include PayPro::Operations::Listable
    include PayPro::Operations::Updatable

    RESOURCE_PATH = 'subscriptions'

    def cancel
      self.class.api_request(method: 'delete', uri: resource_url)
    end

    def pause
      self.class.api_request(method: 'post', uri: "#{resource_url}/pause")
    end

    def resume
      self.class.api_request(method: 'post', uri: "#{resource_url}/resume")
    end

    def subscription_periods
      self.class.api_request(
        method: 'get',
        uri: "#{resource_url}/subscription_periods"
      )
    end

    def create_subscription_period(**body)
      self.class.api_request(
        method: 'post',
        uri: "#{resource_url}/subscription_periods",
        body: body.to_json
      )
    end
  end
end

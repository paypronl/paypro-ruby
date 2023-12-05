# frozen_string_literal: true

module PayPro
  class Subscription < Entity
    def self.get(id)
      api_request(method: 'get', uri: "/subscriptions/#{CGI.escape(id)}")
    end

    def self.list(**kwargs)
      api_request(method: 'get', uri: '/subscriptions', params: kwargs)
    end

    def self.create(**body)
      api_request(method: 'post', uri: '/subscriptions', body: body.to_json)
    end

    def update(**body)
      self.class.api_request(method: 'patch', uri: "/subscriptions/#{CGI.escape(id)}", body: body.to_json)
    end

    def cancel
      self.class.api_request(method: 'delete', uri: "/subscriptions/#{CGI.escape(id)}")
    end

    def pause
      self.class.api_request(method: 'post', uri: "/subscriptions/#{CGI.escape(id)}/pause")
    end

    def resume
      self.class.api_request(method: 'post', uri: "/subscriptions/#{CGI.escape(id)}/resume")
    end

    def subscription_periods
      self.class.api_request(
        method: 'get',
        uri: "/subscriptions/#{CGI.escape(id)}/subscription_periods"
      )
    end

    def create_subscription_period(**body)
      self.class.api_request(
        method: 'post',
        uri: "/subscriptions/#{CGI.escape(id)}/subscription_periods",
        body: body.to_json
      )
    end
  end
end

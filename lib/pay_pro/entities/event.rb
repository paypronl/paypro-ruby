# frozen_string_literal: true

module PayPro
  class Event < Entity
    def self.get(id)
      api_request(method: 'get', uri: "/events/#{CGI.escape(id)}")
    end

    def self.list(**kwargs)
      api_request(method: 'get', uri: '/events', params: kwargs)
    end
  end
end

# frozen_string_literal: true

module PayPro
  class Response
    attr_accessor :request_id,
                  :data,
                  :raw_body,
                  :status

    def self.from_response(response_object)
      response = new

      response.data = JSON.parse(response_object.body)
      response.raw_body = response_object.body
      response.status = response_object.status
      response.request_id = response_object.headers['x-request-id']

      response
    end
  end
end

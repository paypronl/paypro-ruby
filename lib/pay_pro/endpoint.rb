# frozen_string_literal: true

module PayPro
  class Endpoint
    include PayPro::Operations::Requestable

    attr_reader :api_client

    def initialize(api_client:)
      @api_client = api_client
    end

    private

    def resource_url
      "/#{resource_path}"
    end
  end
end

# frozen_string_literal: true

module PayPro
  # Config saves the configuration options
  class Config
    DEFAULT_TIMEOUT = 30

    ATTRIBUTES = %i[api_key api_url timeout].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize
      @api_key = nil
      @api_url = API_URL
      @timeout = DEFAULT_TIMEOUT
    end

    def merge(hash)
      dup.tap do |instance|
        hash.slice(*ATTRIBUTES).each do |key, value|
          instance.public_send("#{key}=", value)
        end
      end
    end
  end
end

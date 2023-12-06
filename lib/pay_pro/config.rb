# frozen_string_literal: true

module PayPro
  # Config saves the configuration options
  class Config
    DEFAULT_CA_BUNDLE_PATH = File.join(__dir__, 'data/cacert.pem')
    DEFAULT_TIMEOUT = 30
    DEFAULT_VERIFY_SSL = true

    ATTRIBUTES = %i[api_key api_url ca_bundle_path timeout verify_ssl].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize
      @api_key = nil
      @api_url = API_URL
      @ca_bundle_path = DEFAULT_CA_BUNDLE_PATH
      @timeout = DEFAULT_TIMEOUT
      @verify_ssl = DEFAULT_VERIFY_SSL
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

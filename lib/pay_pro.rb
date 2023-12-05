# frozen_string_literal: true

require 'pay_pro/version'

require 'cgi'
require 'faraday'
require 'json'
require 'uri'

require 'pay_pro/client'
require 'pay_pro/config'
require 'pay_pro/errors'
require 'pay_pro/response'
require 'pay_pro/util'

require 'pay_pro/entities/entity'

require 'pay_pro/entities/chargeback'
require 'pay_pro/entities/customer'
require 'pay_pro/entities/event'
require 'pay_pro/entities/list'
require 'pay_pro/entities/pay_method'
require 'pay_pro/entities/payment'
require 'pay_pro/entities/refund'
require 'pay_pro/entities/subscription'
require 'pay_pro/entities/subscription_period'
require 'pay_pro/entities/webhook'

module PayPro
  API_URL = 'https://api.paypro.nl'

  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
    end

    def api_key=(api_key)
      configure do |config|
        config.api_key = api_key
      end
    end
  end
end

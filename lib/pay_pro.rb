# frozen_string_literal: true

require 'pay_pro/version'

require 'cgi'
require 'faraday'
require 'json'
require 'uri'
require 'openssl'

require 'pay_pro/api_client'
require 'pay_pro/client'
require 'pay_pro/config'
require 'pay_pro/errors'
require 'pay_pro/response'
require 'pay_pro/signature'
require 'pay_pro/util'

require 'pay_pro/operations/creatable'
require 'pay_pro/operations/deletable'
require 'pay_pro/operations/getable'
require 'pay_pro/operations/listable'
require 'pay_pro/operations/requestable'
require 'pay_pro/operations/updatable'

require 'pay_pro/endpoint'

require 'pay_pro/endpoints/chargebacks'
require 'pay_pro/endpoints/customers'
require 'pay_pro/endpoints/events'
require 'pay_pro/endpoints/mandates'
require 'pay_pro/endpoints/pay_methods'
require 'pay_pro/endpoints/payments'
require 'pay_pro/endpoints/refunds'
require 'pay_pro/endpoints/subscription_periods'
require 'pay_pro/endpoints/subscriptions'
require 'pay_pro/endpoints/webhooks'

require 'pay_pro/entities/entity'
require 'pay_pro/entities/resource'

require 'pay_pro/entities/chargeback'
require 'pay_pro/entities/customer'
require 'pay_pro/entities/event'
require 'pay_pro/entities/list'
require 'pay_pro/entities/mandate'
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

    # Shortcut method to directly set the API key
    def api_key=(api_key)
      configure do |config|
        config.api_key = api_key
      end
    end
  end
end

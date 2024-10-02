# frozen_string_literal: true

module PayPro
  class Client
    attr_accessor :config

    attr_reader :chargebacks,
                :customers,
                :events,
                :mandates,
                :pay_methods,
                :payments,
                :refunds,
                :subscription_periods,
                :subscriptions,
                :webhooks

    def initialize(config = {})
      @config = case config
                when Hash
                  PayPro.config.merge(config)
                when String
                  PayPro.config.merge(api_key: config)
                when PayPro::Config
                  config
                else
                  raise ConfigurationError.new(message: "Invalid argument: #{config}")
                end

      check_api_key!
      setup_endpoints
    end

    private

    def check_api_key!
      return unless @config.api_key.nil? || @config.api_key == ''

      raise ConfigurationError.new(
        message: 'API key not set or given. ' \
                 'Make sure to pass an API key or set a default with "PayPro.api_key=". ' \
                 'You can find your API key in the PayPro dashboard at "https://app.paypro.nl/developers/api-keys".'
      )
    end

    def setup_endpoints
      @chargebacks = Endpoints::Chargebacks.new(api_client: api_client)
      @customers = Endpoints::Customers.new(api_client: api_client)
      @events = Endpoints::Events.new(api_client: api_client)
      @mandates = Endpoints::Mandates.new(api_client: api_client)
      @pay_methods = Endpoints::PayMethods.new(api_client: api_client)
      @payments = Endpoints::Payments.new(api_client: api_client)
      @refunds = Endpoints::Refunds.new(api_client: api_client)
      @subscription_periods = Endpoints::SubscriptionPeriods.new(api_client: api_client)
      @subscriptions = Endpoints::Subscriptions.new(api_client: api_client)
      @webhooks = Endpoints::Webhooks.new(api_client: api_client)
    end

    def api_client
      @api_client ||= ApiClient.new(@config)
    end
  end
end

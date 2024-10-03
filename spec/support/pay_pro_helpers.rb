# frozen_string_literal: true

module PayProHelpers
  def default_api_client
    config = PayPro::Config.new.merge(api_key: '1234')
    PayPro::ApiClient.new(config)
  end
end

# frozen_string_literal: true

module PayPro
  class Webhook < Resource
    include PayPro::Operations::Creatable
    include PayPro::Operations::Deletable
    include PayPro::Operations::Listable
    include PayPro::Operations::Updatable

    RESOURCE_PATH = 'webhooks'
  end
end

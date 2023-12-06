# frozen_string_literal: true

module PayPro
  class Chargeback < Resource
    include PayPro::Operations::Listable

    RESOURCE_PATH = 'chargebacks'
  end
end

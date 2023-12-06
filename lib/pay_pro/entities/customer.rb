# frozen_string_literal: true

module PayPro
  class Customer < Resource
    include PayPro::Operations::Creatable
    include PayPro::Operations::Deletable
    include PayPro::Operations::Listable
    include PayPro::Operations::Updatable

    RESOURCE_PATH = 'customers'
  end
end

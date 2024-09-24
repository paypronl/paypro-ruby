# frozen_string_literal: true

module PayPro
  class Mandate < Resource
    include PayPro::Operations::Creatable
    include PayPro::Operations::Listable

    RESOURCE_PATH = 'mandates'
  end
end

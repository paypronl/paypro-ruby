# frozen_string_literal: true

module PayPro
  class Event < Resource
    include PayPro::Operations::Listable

    RESOURCE_PATH = 'events'
  end
end

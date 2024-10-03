# frozen_string_literal: true

module PayPro
  class Entity
    attr_reader :api_client

    def self.create_from_data(data, api_client:)
      attributes = Util.normalize_api_attributes(data)
      new(attributes: attributes, api_client: api_client)
    end

    private_class_method :new

    def initialize(api_client:, attributes: {})
      @api_client = api_client
      @attributes = attributes

      generate_accessors(attributes)
    end

    def inspect
      "#<#{self.class}> #{JSON.pretty_generate(@attributes)}"
    end

    private

    def generate_accessors(attributes)
      attributes.each do |name, value|
        self.class.instance_eval do
          define_method(name) { instance_variable_get("@#{name}") }

          define_method("#{name}=") do |v|
            instance_variable_set("@#{name}", v)
          end
        end

        send("#{name}=", Util.to_entity(value, api_client: api_client))
      end
    end
  end
end

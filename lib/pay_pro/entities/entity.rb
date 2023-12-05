# frozen_string_literal: true

module PayPro
  class Entity
    def self.create_from_data(data)
      attributes = Util.normalize_api_attributes(data)
      new(attributes: attributes)
    end

    def self.api_request(method:, uri:, params: {}, body: nil)
      client = PayPro::Client.default_client

      response = client.request(method: method, uri: uri, params: params, body: body)
      Util.to_entity(response.data, params: params)
    end

    def initialize(attributes: {})
      generate_accessors(attributes)
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

        send("#{name}=", Util.to_entity(value))
      end
    end
  end
end

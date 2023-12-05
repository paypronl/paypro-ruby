# frozen_string_literal: true

module PayPro
  class Util
    class << self
      # Searches the entities folder for a valid entity class based on a string. This string will
      # be returned in the API as the 'type' parameter.
      #
      # If the class cannot be found it will fallback to the base class Entity.
      def entity_class(string)
        parts = string.split('_')
        class_name = parts.map { |part| part.downcase.capitalize }.join
        PayPro.const_get(class_name, false)
      rescue NameError
        Entity
      end

      def normalize_api_attributes(attributes)
        new_attributes = attributes.dup

        new_attributes.delete('type')
        new_attributes['links'] = new_attributes.delete('_links') if new_attributes['_links']
        new_attributes
      end

      # Creates an Enity class or returns the data if the data cannot be converted to an entity.
      #
      # It will try to find an API entity class, if it cannot be found it will fallback to the
      # default Entity class.
      def to_entity(data, params: {})
        case data
        when Array
          data.map { |i| to_entity(i) }
        when Hash
          if data.key?('type')
            entity = entity_class(data['type']).create_from_data(data)
            entity.filters = params if entity.is_a?(PayPro::List)
            entity
          else
            data.transform_values { |value| to_entity(value) }
          end
        else
          data
        end
      end
    end
  end
end

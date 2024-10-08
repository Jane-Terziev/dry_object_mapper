# frozen_string_literal: true

module DryObjectMapper
  class Mapper
    @@definitions = {}

    def self.definitions
      @@definitions
    end

    def self.call(model_object, struct_dto, options = {})
      if @@definitions[struct_dto]
        schema_definition = @@definitions[struct_dto]
      else
        schema_definition = DryStructParser::StructSchemaParser.new.call(struct_dto).keys
        @@definitions[struct_dto] = schema_definition
      end

      if model_object.respond_to?(:each)
        model_object = model_object.to_a
        result = model_object.map do |it|
          struct_dto.new(get_model_hash_from_definition(it, schema_definition, options))
        end
      else
        result = struct_dto.new(get_model_hash_from_definition(model_object, schema_definition, options))
      end

      result
    end

    def self.get_model_hash_from_definition(model_object, schema_definition, options)
      result = {}
      schema_definition.each do |field_name, definition|
        if options&.key?(field_name.to_sym)
          result[field_name] = options[field_name.to_sym]
        elsif definition[:type] == "hash"
          if model_object.send(field_name).nil?
            result[field_name] = nil
          else
            result[field_name] =
              get_model_hash_from_definition(model_object.send(field_name), definition[:keys], options&.dig(field_name))
          end
        elsif definition[:type] == "array" && !definition[:keys]&.empty?
          result[field_name] = []
          model_object.send(field_name).each do |object|
            result[field_name] << get_model_hash_from_definition(object, definition[:keys], options&.dig(field_name))
          end
        else
          result[field_name] = model_object.send(field_name)
        end
      end

      result
    end
  end
end

# frozen_string_literal: true

def deep_open_struct_to_hash(object)
  object.each_pair.with_object({}) do |(key, value), hash|
    hash[key] = if value.is_a?(OpenStruct)
                  deep_open_struct_to_hash(value)
                elsif value.is_a?(Array)
                  value.first.is_a?(OpenStruct) ? value.map { |v| deep_open_struct_to_hash(v) } : value
                else
                  value
                end
  end
end

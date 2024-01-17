def deep_open_struct_to_hash(object)
  object.each_pair.with_object({}) do |(key, value), hash|
    if value.is_a?(OpenStruct)
      hash[key] = deep_open_struct_to_hash(value)
    elsif value.is_a?(Array)
      hash[key] = value.first.is_a?(OpenStruct) ? value.map{|v| deep_open_struct_to_hash(v) } : value
    else
      hash[key] = value
    end
  end
end
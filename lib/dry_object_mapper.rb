# frozen_string_literal: true

require_relative "dry_object_mapper/version"
require "dry_struct_parser/struct_schema_parser"
require_relative "dry_object_mapper/mapper"
require_relative "dry_object_mapper/types"

module DryObjectMapper
  class Error < StandardError; end
  # Your code goes here...
end

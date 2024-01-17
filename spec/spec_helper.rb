# frozen_string_literal: true

require "dry_object_mapper"
require "dry-struct"
require "ostruct"
require_relative 'support/open_struct_to_hash'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

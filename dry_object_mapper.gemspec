# frozen_string_literal: true

require_relative "lib/dry_object_mapper/version"

Gem::Specification.new do |spec|
  spec.name = "dry_object_mapper"
  spec.version = DryObjectMapper::VERSION
  spec.authors = ["Jane-Terziev"]
  spec.email = ["janeterziev@gmail.com"]

  spec.summary = "Transform your ActiveRecord objects into Dry::Struct objects"
  spec.description = "Transform your ActiveRecord objects into Dry::Struct objects"
  spec.homepage = "https://github.com/Jane-Terziev/dry_object_mapper"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Jane-Terziev/dry_object_mapper"
  spec.metadata["changelog_uri"] = "https://github.com/Jane-Terziev/dry_object_mapper"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-struct", "~> 1"
  spec.add_dependency "dry_struct_parser"
end

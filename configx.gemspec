# frozen_string_literal: true

require_relative "lib/config_x/version"

Gem::Specification.new do |spec|
  spec.name = "configx"
  spec.version = ConfigX::VERSION
  spec.authors = ["Tëma Bolshakov"]
  spec.email = ["tema@bolshakov.dev"]

  spec.summary = "Configuration simplified"
  spec.description = <<~DESC
    ConfigX is a Ruby library for configuration management. It provides battle-tested defaults
    and an intuitive interface for managing settings from YAML files and environment variables.
    It also offers flexibility for developers to build their own configurations.
  DESC
  spec.homepage = "https://github.com/bolshakov/configx"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile sig/shims/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "deep_merge"
  spec.add_dependency "zeitwerk"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

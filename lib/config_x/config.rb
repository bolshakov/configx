# frozen_string_literal: true

begin
  require "dry-struct"
rescue LoadError
  raise "The dry-struct gem is required for ConfigX::TypedConfig"
end

module ConfigX
  class Config < Dry::Struct
    transform_keys(&:to_sym)

    include Configurable
  end
end

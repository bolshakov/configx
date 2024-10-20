# frozen_string_literal: true

require "zeitwerk"
require_relative "config_x/version"

module ConfigX
  class << self
    # @api private
    # @return [Zeitwerk::Loader]
    def loader
      @loader ||= Zeitwerk::Loader.for_gem.tap do |loader|
        loader.ignore("#{__dir__}/configx.rb")
      end
    end

    # @return [Configurable]
    def load(...) = ConfigFactory.load(...)

    # Loads config from the given source
    # @example
    #   config = ConfigX.from({api: {endpoint: "http://example.com", enabled: true}})
    #   config.api.endpoint # => "http://example.com"
    #   config.api.enabled # => true
    # @return [ConfigX::UntypedConfig]
    def from(source, **args) = builder.add_source(source, **args).load(config_class: UntypedConfig)

    # @return [ConfigX::Builder]
    private def builder = Builder.new
  end
end

ConfigX.loader.setup

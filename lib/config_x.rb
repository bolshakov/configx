# frozen_string_literal: true

require "zeitwerk"
require_relative "config_x/version"

module ConfigX
  class << self
    # @api private
    def loader
      @loader ||= Zeitwerk::Loader.for_gem.tap do |loader|
        loader.ignore("#{__dir__}/configx.rb")
      end
    end

    def load(...) = ConfigFactory.load(...)

    def builder = Builder.new

    # Loads config from the given source
    # @example
    #   config = ConfigX.from({api: {endpoint: "http://example.com", enabled: true}})
    #   config.api.endpoint # => "http://example.com"
    #   config.api.enabled # => true
    #
    def from(source, **args) = builder.add_source(source, **args).load
  end
end

ConfigX.loader.setup

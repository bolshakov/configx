# frozen_string_literal: true

require "deep_merge/core"

module ConfigX
  class Builder
    class << self
      def source(source, **args)
        case source
        in Source then source
        in Hash then HashSource.new(source)
        in String then FileSource.new(source)
        in Pathname then FileSource.new(source)
        in ENV then EnvSource.new(ENV, **args)
        end
      end

      # @see #initialize
      def load(...)
        new(...).load
      end
    end

    # @example
    #   ConfigX.new("production").load
    #   ConfigX.new.load
    #
    def initialize
      @sources = []
    end

    attr_reader :sources

    def add_source(source, **args)
      sources << self.class.source(source, **args)
      self
    end

    # Loads config in the following order:
    #   1. Reads default config
    #   2. Reads all the config files provided in the order
    #   3. Reads environment variables
    def load
      Config.new(read_from_sources)
    end

    def ==(other)
      other.is_a?(self.class) && other.sources == sources
    end

    private def read_from_sources
      sources.each_with_object({}) do |source, config|
        DeepMerge.deep_merge!(source.load, config, overwrite_arrays: true)
      end
    end
  end
end

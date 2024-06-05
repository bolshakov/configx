# frozen_string_literal: true

require "deep_merge/core"
require "yaml"

module ConfigX
  class EnvSource < HashSource
    def initialize(env, prefix:, separator:)
      @env = env
      @prefix = prefix
      @separator = separator
    end

    def ==(other)
      other.is_a?(self.class) &&
        source == other.source &&
        prefix == other.prefix &&
        separator == other.separator
    end

    protected

    def source
      env.each_with_object({}) do |(key, value), config|
        next unless key.start_with?(prefix + separator)

        Array(key.split(separator)[1..])
          .reverse_each
          .reduce(YAML.load(value)) { |acc, k| {k.downcase => acc} }
          .tap { DeepMerge.deep_merge!(_1, config) }
      end
    end

    attr_reader :env, :prefix, :separator
  end
end

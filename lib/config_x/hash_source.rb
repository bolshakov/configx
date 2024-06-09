# frozen_string_literal: true

require "yaml"

module ConfigX
  class HashSource < Source
    attr_reader :source
    protected :source

    class << self
      def deep_stringify_keys(hash)
        hash.each_with_object({}) do |(key, value), acc|
          acc[key.to_s] =
            if Hash === value
              deep_stringify_keys(value)
            else
              value
            end
        end
      end
    end

    def initialize(source)
      @source = source
    end

    def load
      self.class.deep_stringify_keys(source)
    end

    def ==(other)
      other.is_a?(self.class) && source == other.source
    end
  end
end

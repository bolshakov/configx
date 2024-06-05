# frozen_string_literal: true

require "ostruct"
require "deep_merge/core"

module ConfigX
  class Config < OpenStruct
    def initialize(members)
      super()

      members.each do |key, value|
        raise ArgumentError, "option keys should be strings" unless key.respond_to?(:to_s)

        key = key.to_s

        if value.is_a?(Hash)
          value = self.class.new(value)
        elsif value.is_a?(Array)
          value = value.map do |element|
            element.is_a?(Hash) ? self.class.new(element) : element
          end
        end

        self[key] = value.freeze
      end

      freeze
    end

    def with_fallback(fallback)
      DeepMerge.deep_merge!(
        to_h,
        fallback.to_h,
        overwrite_arrays: true
      ).then { Config.new(_1) }
    end

    def to_h
      each_pair.each_with_object({}) do |(key, value), hash|
        hash[key] = value.is_a?(Config) ? value.to_h : value
      end
    end
  end
end

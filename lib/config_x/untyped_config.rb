# frozen_string_literal: true

require "ostruct"

module ConfigX
  # The Config class extends OpenStruct to provide a flexible configuration object.
  class UntypedConfig < OpenStruct
    include Configurable

    # @param members [Hash] the initial configuration hash
    # @raise [ArgumentError] if any of the keys are not convertible to strings
    def initialize(members)
      super({})

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

        self[key] = value
      end

      freeze
    end

    # Converts the Config object to a hash.
    #
    # @return [Hash] the configuration as a hash
    def to_h
      each_pair.each_with_object({}) do |(key, value), hash|
        hash[key] = value.is_a?(self.class) ? value.to_h : value
      end
    end
  end
end

# frozen_string_literal: true
require "deep_merge/core"

module ConfigX
  module Configurable
    # @!method to_h
    #   @abstract
    #   @return [Hash]

    # Merges the current configuration with a fallback configuration.
    #
    # @param fallback [Configurable] the fallback configuration
    # @return [Configurable] a new Config object with the merged configuration
    def with_fallback(fallback)
      DeepMerge.deep_merge!(
        to_h,
        fallback.to_h,
        overwrite_arrays: true
      ).then { self.class.new(_1) }
    end
  end
end

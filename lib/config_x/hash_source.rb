# frozen_string_literal: true

require "yaml"

module ConfigX
  class HashSource < Source
    attr_reader :source
    protected :source

    def initialize(source)
      @source = source
    end

    def load = source

    def ==(other)
      other.is_a?(self.class) && source == other.source
    end
  end
end

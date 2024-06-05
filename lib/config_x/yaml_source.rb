# frozen_string_literal: true

require "yaml"

module ConfigX
  class YamlSource < Source
    def initialize(source)
      @source = source
    end

    def load
      YAML.load(source) || {}
    end

    private

    attr_reader :source
  end
end

# frozen_string_literal: true

require "yaml"

module ConfigX
  class FileSource < Source
    def initialize(path)
      @path = path
    end

    def load
      if path && File.exist?(path)
        YamlSource.new(File.read(path.to_s)).load
      else
        {}
      end
    end

    def ==(other)
      other.is_a?(self.class) && other.path == path
    end

    protected

    attr_reader :path
  end
end

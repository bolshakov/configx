# frozen_string_literal: true

module ConfigX
  # This class is responsible for loading configuration settings for an application.
  # It follows a specific order in loading these settings:
  #   1. Reads default config
  #   2. Reads all the config files provided in the order
  #   3. Reads environment variables
  class ConfigFactory
    class << self
      # Default environment variable prefix
      def default_env_prefix = "SETTINGS"

      # Default environment variable separator
      def default_env_separator = "__"

      # Default directory name for environment-specific settings
      def default_dir_name = "settings"

      # Default environment name
      def default_env = "production"

      # Default config file name
      def default_file_name = "settings"

      # Default root directory for configuration
      def default_config_root = "config"

      # Load method to initialize and load the configuration
      def load(...) = new(...).load
    end

    # Initializes a new instance of the ConfigFactory class.
    # @param env [String] the environment name.
    # @param env_prefix [String] the prefix for environment variables.
    # @param env_separator [String] the separator for environment variables.
    # @param dir_name [String] the directory name for settings.
    # @param file_name [String] the file name for settings.
    # @param config_root [String] the root directory for configuration.
    def initialize(
      env = self.class.default_env,
      env_prefix: self.class.default_env_prefix,
      env_separator: self.class.default_env_separator,
      dir_name: self.class.default_dir_name,
      file_name: self.class.default_file_name,
      config_root: self.class.default_config_root
    )
      @env = env
      @env_prefix = env_prefix
      @env_separator = env_separator
      @dir_name = dir_name
      @file_name = file_name
      @config_root = config_root
    end

    # Loads the configuration from the sources and additional sources.
    # @param additional_sources [Array] additional sources to load configuration from.
    # @return [Config] the loaded configuration.
    def load(*additional_sources)
      (sources + additional_sources)
        .reduce(Builder.new) { |builder, source| builder.add_source(source) }
        .load
    end

    private

    # Returns the sources from which to load the configuration.
    # @return [Array] the sources.
    def sources
      [
        *setting_files,
        Builder.source(ENV, prefix: env_prefix, separator: env_separator)
      ]
    end

    # Returns the setting files.
    # @return [Array] the setting files.
    def setting_files
      [
        File.join(config_root, "#{file_name}.yml"),
        File.join(config_root, dir_name, "#{env}.yml"),
        *local_setting_files
      ].freeze
    end

    # Returns the local setting files.
    # @return [Array] the local setting files.
    def local_setting_files
      [
        (File.join(config_root, "#{file_name}.local.yml") if env != "test"),
        File.join(config_root, dir_name, "#{env}.local.yml")
      ].compact
    end

    # The root directory for configuration.
    attr_reader :config_root

    # The directory name for environment-specific settings.
    attr_reader :dir_name

    # The environment name.
    attr_reader :env

    # The prefix for environment variables.
    attr_reader :env_prefix

    # The separator for environment variables.
    attr_reader :env_separator

    # The file name for settings.
    attr_reader :file_name
  end
end

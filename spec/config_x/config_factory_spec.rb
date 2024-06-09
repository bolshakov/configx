# frozen_string_literal: true

RSpec.describe ConfigX::ConfigFactory do
  shared_examples "option with default" do |option, default:|
    describe "ConfigX::ConfigFactory##{option}" do
      context "when value is not provided" do
        subject { config_factory.__send__(option) }

        let(:config_factory) { described_class.new }

        it "fallbacks to default value `#{default}`" do
          is_expected.to eq(default)
        end
      end
    end
  end

  include_examples "option with default", :env, default: "production"
  include_examples "option with default", :env_prefix, default: "SETTINGS"
  include_examples "option with default", :env_separator, default: "__"
  include_examples "option with default", :dir_name, default: "settings"
  include_examples "option with default", :file_name, default: "settings"

  describe ".load" do
    context "when config files are present" do
      subject(:config_factory) do
        described_class.new(
          "development",
          config_root: "spec/support/config"
        ).load
      end

      around do |example|
        settings__three = ENV["SETTINGS__ONE__THREE"]
        ENV["SETTINGS__ONE__THREE"] = "environment variable"
        example.run
        ENV["SETTINGS__ONE__THREE"] = settings__three
      end

      it "loads config files in order" do
        is_expected.to have_attributes(
          one: have_attributes(
            two: "settings/development.local.yml",
            three: "environment variable"
          ),
          four: "settings.local.yml",
          five: "settings/development.yml",
          six: "settings.yml"
        )
      end
    end
  end

  describe "#load" do
    subject(:config_factory) do
      described_class.new(
        "development",
        config_root: "spec/support/config"
      ).load(*additional_sources)
    end

    let(:additional_sources) do
      [
        {one: {two: "additional hash source"}}
      ]
    end

    it "loads config files in order" do
      is_expected.to have_attributes(
        one: have_attributes(
          two: "additional hash source",
          three: "settings/development.local.yml"
        ),
        four: "settings.local.yml",
        five: "settings/development.yml",
        six: "settings.yml"
      )
    end
  end
end

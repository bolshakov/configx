# frozen_string_literal: true

require "support/types"

RSpec.describe ConfigX do
  describe ".from" do
    subject(:from) { described_class.from(source) }

    let(:source) { {foo: {bar: 42}} }

    it { is_expected.to have_attributes(foo: have_attributes(bar: 42)) }
  end

  describe ".load" do
    subject(:load) { described_class.load("development", config_class:, config_root:) }

    let(:config_root) { "spec/support/config" }

    context "when typed config" do
      let(:config_class) do
        Class.new(ConfigX::Config) do
          attribute :one do
            attribute :three, Types::String
          end
          attribute :four, Types::String
          attribute :five, Types::String
        end
      end

      it "loads config files in order" do
        is_expected.to be_kind_of(ConfigX::Config)
        is_expected.to have_attributes(
          one: have_attributes(
            three: "settings/development.local.yml"
          ),
          four: "settings.local.yml",
          five: "settings/development.yml"
        )
      end
    end

    context "when untyped config" do
      let(:config_class) { ConfigX::UntypedConfig }

      it "loads config files in order" do
        is_expected.to have_attributes(
          one: have_attributes(
            three: "settings/development.local.yml"
          ),
          four: "settings.local.yml",
          five: "settings/development.yml",
          six: "settings.yml"
        )
      end
    end
  end
end

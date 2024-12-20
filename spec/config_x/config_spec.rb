# frozen_string_literal: true

require "support/types"

RSpec.describe ConfigX::Config do
  describe ".new" do
    subject(:options) { config_class.new(hash) }

    context "when plain hash" do
      let(:hash) { {"foo" => "bar", "bar" => 42} }
      let(:config_class) do
        Class.new(described_class) do
          attribute :foo, Types::String
          attribute :bar, Types::Integer
        end
      end

      it { is_expected.to have_attributes(foo: "bar", bar: 42) }
    end

    context "when nested settings" do
      let(:hash) do
        {"foo" => {"bar" => 42}}
      end
      let(:config_class) do
        Class.new(described_class) do
          attribute :foo do
            attribute :bar, Types::Integer
          end
        end
      end

      it "converts it to options" do
        is_expected.to have_attributes(
          foo: have_attributes(bar: 42)
        )
      end
    end

    context "when hash inside an array" do
      let(:hash) do
        {"foo" => [{"bar" => 42}]}
      end
      let(:config_class) do
        Class.new(described_class) do
          attribute :foo, Types::Array do
            attribute :bar, Types::Integer
          end
        end
      end

      it "converts it to options" do
        is_expected.to have_attributes(
          foo: [
            have_attributes(bar: 42)
          ]
        )
      end
    end
  end

  describe "#with_fallback" do
    subject { config.with_fallback(fallback) }
    let(:config_class) do
      Class.new(described_class) do
        attribute :foo, Types::String
        attribute :bar do
          attribute? :baz, Types::Integer
          attribute? :default, Types::String
        end
      end
    end

    let(:config) do
      config_class.new(
        {
          foo: "bar",
          bar: {baz: 42}
        }
      )
    end

    let(:fallback) do
      config_class.new(
        {
          foo: "default foo",
          bar: {default: "default"}
        }
      )
    end

    it "defaults missing options to fallback" do
      is_expected.to have_attributes(
        foo: "bar",
        bar: have_attributes(baz: 42, default: "default")
      )
    end
  end
end

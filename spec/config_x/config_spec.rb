# frozen_string_literal: true

RSpec.describe ConfigX::Config do
  describe ".new" do
    subject(:options) { described_class.new(hash) }

    context "when plain hash" do
      let(:hash) { {"foo" => "bar", "bar" => 42} }

      it { is_expected.to have_attributes(foo: "bar", bar: 42) }
    end

    context "when nested hash" do
      let(:hash) do
        {"foo" => {"bar" => 42}}
      end

      it "converts it to options" do
        is_expected.to have_attributes(
          foo: have_attributes(bar: 42)
        )
      end
    end

    context "when hash inside an array" do
      let(:hash) do
        {"foo" => [664, {"bar" => 42}]}
      end

      it "converts it to options" do
        is_expected.to have_attributes(
          foo: [
            664,
            have_attributes(bar: 42)
          ]
        )
      end
    end
  end

  describe "#to_h" do
    subject { options.to_h }

    let(:options) { described_class.new(hash) }
    let(:hash) do
      {
        foo: "bar",
        bar: {
          nested_option: 42,
          nested: {opt: 664}
        }
      }
    end

    it { is_expected.to eq(hash) }
  end

  describe "#with_fallback" do
    subject { config.with_fallback(fallback) }
    let(:config) do
      described_class.new(
        {
          foo: "bar",
          bar: {baz: 42}
        }
      )
    end

    let(:fallback) do
      described_class.new(
        {
          foo: "default foo",
          baz: 664,
          bar: {default: "default"}
        }
      )
    end

    it "defaults missing options to fallback" do
      is_expected.to have_attributes(
        foo: "bar",
        baz: 664,
        bar: have_attributes(baz: 42, default: "default")
      )
    end
  end
end

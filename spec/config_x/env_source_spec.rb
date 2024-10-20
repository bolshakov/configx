# frozen_string_literal: true

RSpec.describe ConfigX::EnvSource do
  subject(:config) { source.load }

  let(:source) { described_class.new(env, prefix: "MY_CONFIG", separator: "__") }

  context "without configuration" do
    let(:env) { {"CONFIG__FOO" => "bar"} }

    it "reads nothing" do
      is_expected.to be_empty
    end
  end

  context "with top level configuration" do
    let(:env) do
      {
        "MY_CONFIG__FOO" => "bar",
        "MY_CONFIG__BAR" => "baz"
      }
    end

    it "reads top-level configuration" do
      is_expected.to eq({"foo" => "bar", "bar" => "baz"})
    end
  end

  context "with nested configuration" do
    let(:env) do
      {
        "MY_CONFIG__FOO__BAR__BAZ" => "one",
        "MY_CONFIG__FOO__BAR__BAT" => "two",
        "MY_CONFIG__FOO__BAZ" => "three"
      }
    end

    it "reads configuration" do
      is_expected.to eq({
        "foo" => {
          "bar" => {
            "baz" => "one",
            "bat" => "two"
          },
          "baz" => "three"
        }
      })
    end
  end

  context "with typed configuration" do
    let(:env) do
      {
        "MY_CONFIG__ONE" => "on",
        "MY_CONFIG__TWO" => "off",
        "MY_CONFIG__THREE" => "true",
        "MY_CONFIG__FOUR" => "false",
        "MY_CONFIG__FIVE" => "null",
        "MY_CONFIG__SIX" => "42",
        "MY_CONFIG__SEVEN" => "64.4",
        "MY_CONFIG__EIGHT" => "foo,bar",
        "MY_CONFIG__NINE" => '["foo","bar"]'
      }
    end

    it "parses types" do
      is_expected.to eq({
        "one" => true,
        "two" => false,
        "three" => true,
        "four" => false,
        "five" => nil,
        "six" => 42,
        "seven" => 64.4,
        "eight" => "foo,bar",
        "nine" => ["foo", "bar"]
      })
    end
  end
end

# frozen_string_literal: true

RSpec.describe ConfigX::YamlSource do
  let(:config) { described_class.new(source_string).load }

  let(:source_string) { <<~YAML }
    ---
    one: off
    two: true
    three: null
    four:
      bar: 42
  YAML

  it "loads string into hash" do
    expect(config).to eq({
      "one" => false,
      "two" => true,
      "three" => nil,
      "four" => {"bar" => 42}
    })
  end
end

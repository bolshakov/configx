# frozen_string_literal: true

RSpec.describe ConfigX::HashSource do
  let(:config) { described_class.new(hash).load }

  let(:hash) do
    {
      "one" => false,
      "two" => true,
      "three" => nil,
      "four" => {"bar" => 42}
    }
  end

  it { expect(config).to eq(hash) }

  context "when keys are symbols" do
    let(:hash) { {four: {bar: 42}} }

    it "deep stringifies keys" do
      expect(config).to eq("four" => {"bar" => 42})
    end
  end
end

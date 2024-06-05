# frozen_string_literal: true

RSpec.describe ConfigX do
  describe ".builder" do
    subject(:builder) { described_class.builder }

    it { is_expected.to eq(ConfigX::Builder.new) }
  end

  describe ".from" do
    subject(:from) { described_class.from(source) }

    let(:source) { {foo: {bar: 42}} }

    it { is_expected.to have_attributes(foo: have_attributes(bar: 42)) }
  end
end

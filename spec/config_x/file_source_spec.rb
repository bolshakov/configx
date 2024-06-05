# frozen_string_literal: true

require "tempfile"

RSpec.describe ConfigX::FileSource do
  subject(:config) { described_class.new(path).load }

  context "when file exists" do
    let(:path) { file.path }
    let(:file) { Tempfile.new }
    let(:source_string) { <<~YAML }
      ---
      one: off
      two: true
      three: null
      four:
        bar: 42
    YAML

    before do
      file.write(source_string)
      file.rewind
    end

    it "loads file into hash" do
      is_expected.to eq({
        "one" => false,
        "two" => true,
        "three" => nil,
        "four" => {"bar" => 42}
      })
    end
  end

  context "when file does not exist" do
    let(:path) { SecureRandom.uuid }

    it "returns empty hash" do
      is_expected.to be_empty
    end
  end
end

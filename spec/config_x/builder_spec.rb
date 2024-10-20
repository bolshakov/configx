# frozen_string_literal: true

RSpec.describe ConfigX::Builder do
  describe ".source" do
    subject { described_class.source(source) }

    context "when an instance of Source" do
      let(:source) { ConfigX::YamlSource.new("") }

      it { is_expected.to be(source) }
    end

    context "when an instance of Hash" do
      let(:source) { {"foo" => "bar"} }

      it { is_expected.to eq(ConfigX::HashSource.new(source)) }
    end

    context "when an instance of String" do
      let(:source) { file.path }
      let(:file) { Tempfile.new }

      after { file.unlink }

      it { is_expected.to eq(ConfigX::FileSource.new(source)) }
    end

    context "when an instance of Pathname" do
      let(:source) { Pathname(file.path) }
      let(:file) { Tempfile.new }

      after { file.unlink }

      it { is_expected.to eq(ConfigX::FileSource.new(source)) }
    end

    context "when ENV" do
      subject { described_class.source(source, prefix:, separator:) }
      let(:source) { ENV }
      let(:prefix) { SecureRandom.uuid }
      let(:separator) { SecureRandom.uuid }

      it do
        is_expected.to eq(ConfigX::EnvSource.new(source, prefix:, separator:))
      end
    end
  end

  describe "#add_source" do
    let(:config) { described_class.new }
    let(:hash_source) { {"foo" => "bar"} }

    it "adds source" do
      expect do
        config.add_source(hash_source)
      end.to change { config.sources }.to(include(ConfigX::HashSource.new(hash_source)))
    end
  end

  describe ".load" do
    subject(:config) do
      described_class
        .new
        .add_source(source1)
        .add_source(source2)
        .load(config_class: ConfigX::UntypedConfig)
    end

    let(:source1) do
      {
        "foo" => "bar",
        "bar" => "baz",
        "array" => [1, 2, 3],
        "nested" => {
          "one" => "one",
          "tow" => 2
        }
      }
    end

    let(:source2) do
      {
        "bar" => 42,
        "array" => [3, 4, 5],
        "nested" => {
          "one" => 1
        }
      }
    end

    it "merge sources" do
      is_expected.to eq(
        ConfigX::UntypedConfig.new({
          "foo" => "bar",
          "bar" => 42,
          "array" => [3, 4, 5],
          "nested" => {
            "one" => 1,
            "tow" => 2
          }
        })
      )
    end
  end
end

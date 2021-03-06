# frozen_string_literal: true

RSpec.describe Karafka::Extensions::MetadataBuilder do
  describe '#from_hash' do
    subject(:params) { Karafka::Params::Builders::Metadata.from_hash(hash, topic) }

    let(:hash) { { 'key' => rand } }
    let(:topic) { instance_double(Karafka::Routing::Topic, deserializer: Class.new) }

    it { expect(params['deserializer']).to eq topic.deserializer }
    it { expect(params['key']).to eq hash['key'] }
    it { is_expected.to be_a(Karafka::Params::Metadata) }
  end
end

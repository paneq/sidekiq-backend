# frozen_string_literal: true

RSpec.describe Karafka::Consumers::Includer do
  subject(:includer) { described_class.new(topic) }

  let(:consumer) { Class.new(Karafka::BaseConsumer).new(topic) }
  let(:features_scope) { Karafka::Consumers }
  let(:backends_scope) { Karafka::Backends }
  let(:consumer_singleton) { consumer.singleton_class }
  let(:topic) do
    instance_double(
      Karafka::Routing::Topic,
      backend: backend,
      batch_consuming: batch_consuming,
      responder: responder,
      batch_fetching: true
    )
  end

  describe 'inline with batch consuming' do
    let(:backend) { :inline }
    let(:batch_consuming) { true }
    let(:responder) { nil }

    it { expect(consumer_singleton.include?(backends_scope::Inline)).to eq true }
    it { expect(consumer_singleton.include?(backends_scope::Sidekiq)).to eq false }
    it { expect(consumer_singleton.include?(features_scope::SingleParams)).to eq false }
    it { expect(consumer_singleton.include?(features_scope::Responders)).to eq false }
  end

  describe 'inline without batch consuming' do
    let(:backend) { :inline }
    let(:batch_consuming) { false }
    let(:responder) { nil }

    it { expect(consumer_singleton.include?(backends_scope::Inline)).to eq true }
    it { expect(consumer_singleton.include?(backends_scope::Sidekiq)).to eq false }
    it { expect(consumer_singleton.include?(features_scope::SingleParams)).to eq true }
    it { expect(consumer_singleton.include?(features_scope::Responders)).to eq false }
  end

  describe 'inline with responder' do
    let(:backend) { :inline }
    let(:batch_consuming) { false }
    let(:responder) { Class.new }

    it { expect(consumer_singleton.include?(backends_scope::Inline)).to eq true }
    it { expect(consumer_singleton.include?(backends_scope::Sidekiq)).to eq false }
    it { expect(consumer_singleton.include?(features_scope::SingleParams)).to eq true }
    it { expect(consumer_singleton.include?(features_scope::Responders)).to eq true }
  end

  describe 'sidekiq with responder' do
    let(:backend) { :sidekiq }
    let(:batch_consuming) { false }
    let(:responder) { Class.new }

    it { expect(consumer_singleton.include?(backends_scope::Inline)).to eq false }
    it { expect(consumer_singleton.include?(backends_scope::Sidekiq)).to eq true }
    it { expect(consumer_singleton.include?(features_scope::SingleParams)).to eq true }
    it { expect(consumer_singleton.include?(features_scope::Responders)).to eq true }
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::PaymentProviderFactory do
  describe '.register' do
    it 'registers a new payment provider' do
      provider_class = Class.new
      described_class.register(:new_provider, provider_class)
      expect(described_class.provider(:new_provider)).to be_a(provider_class)
    end
  end

  describe '.provider' do
    context 'when id is nil' do
      it 'returns a new instance of the default (flaky) provider' do
        provider = described_class.provider
        expect(provider).to be_a(Payments::FlakyPaymentProvider)
      end
    end

    context 'when id is given' do
      context 'and a provider is registered for that id' do
        it 'returns a new instance of the registered provider' do
          provider_class = Class.new
          described_class.register(:test_provider, provider_class)
          provider = described_class.provider(:test_provider)
          expect(provider).to be_a(provider_class)
        end
      end

      context 'and no provider is registered for that id' do
        it 'returns a new instance of the default provider' do
          provider = described_class.provider(:nonexistent_provider)
          expect(provider).to be_a(Payments::FlakyPaymentProvider)
        end
      end
    end
  end
end

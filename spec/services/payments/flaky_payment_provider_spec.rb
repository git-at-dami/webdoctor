# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::FlakyPaymentProvider do
  describe '#debit' do
    context 'when Time.current.to_i is even' do
      it 'returns true' do
        allow(Time).to receive(:current).and_return(Time.zone.at(2)) # Simulate even timestamp

        result = described_class.new.debit(100)
        expect(result).to be true
      end
    end

    context 'when Time.current.to_i is odd' do
      it 'raises a PaymentError' do
        allow(Time).to receive(:current).and_return(Time.zone.at(1)) # Simulate odd timestamp

        expect do
          described_class.new.debit(100)
        end.to raise_error(Payments::FlakyPaymentProvider::PaymentError, 'Failed to charge 100')
      end
    end
  end
end

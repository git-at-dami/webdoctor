# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::ReissuePrescriptionNote, type: :transaction do
  let!(:default_patient_user) { create(:user) }
  let!(:default_doctor_user) { create(:user, is_doctor: true, is_patient: false) }
  let!(:default_admin_user) { create(:user, is_admin: true, is_patient: false) }

  let(:parent_message) { create(:message, outbox: default_doctor_user.outbox, inbox: default_patient_user.inbox) }

  let(:result) { described_class.new.call(parent_message.id) }

  describe '#call' do
    context 'when reissue is successful' do
      before do
        allow_any_instance_of(Payments::FlakyPaymentProvider).to receive(:debit).and_return(true)
      end

      it 'sends the message, processes payment, and creates a payment record' do
        expect(result).to be_success
        expect(Message.first.inbox).to eq(default_admin_user.inbox)
        expect(Message.first.outbox).to eq(default_patient_user.outbox)
        expect(Payment.last.user).to eq(default_patient_user)
        expect(Payment.last.amount).to eq(10)
      end
    end

    context 'when payment fails' do
      before do
        allow_any_instance_of(Payments::FlakyPaymentProvider).to receive(:debit).and_raise(Payments::FlakyPaymentProvider::PaymentError)
      end

      it 'does not send the message or create a payment record' do
        expect(result).to be_failure
        expect { result }.to(not_change { Payment.count })
        expect { result }.to(not_change { Message.count })
      end
    end

    context 'when message creation fails' do
      before do
        allow_any_instance_of(Payments::FlakyPaymentProvider).to receive(:debit).and_return(true)
        allow(Message).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(Message.new))
      end

      it 'rolls back the transaction and does not create a payment record' do
        expect(result).to be_failure
        expect { result }.to(not_change { Payment.count })
        expect { result }.to(not_change { Message.count })
      end
    end
  end
end

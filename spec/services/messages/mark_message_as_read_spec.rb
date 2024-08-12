# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::MarkMessageAsRead do
  let!(:default_patient_user) { create(:user) }
  let!(:default_doctor_user) { create(:user, is_doctor: true, is_patient: false) }
  let(:default_admin_user) { create(:user, is_admin: true, is_patient: false) }

  let(:message) { create(:message, outbox: default_patient_user.outbox, inbox: default_doctor_user.inbox) }

  describe '#call' do
    context 'when the message is unread, recipient is a doctor, and user_type is doctor' do
      it 'marks the message as read and decrements the unread count' do
        expect do
          described_class.new(message, 'doctor').call
        end.to change { message.reload.read }.from(false).to(true)
                                             .and change {
                                                    default_doctor_user.inbox.reload.unread_messages_count
                                                  }.by(-1)
      end
    end

    context 'when the message is already read' do
      let(:message) do
        create(:message, outbox: default_patient_user.outbox, inbox: default_doctor_user.inbox, read: true)
      end

      it 'does not change the message or the unread count' do
        expect do
          described_class.new(message, 'doctor').call
        end.to not_change { message.reload.read }
          .and(not_change { default_doctor_user.inbox.reload.unread_messages_count })
      end
    end

    context 'when the recipient is not a doctor' do
      let(:message) do
        create(:message, outbox: default_doctor_user.outbox, inbox: default_patient_user.inbox, read: true)
      end

      it 'does not change the message or the unread count' do
        expect do
          described_class.new(message, 'doctor').call
        end.to not_change { message.reload.read }
          .and(not_change { default_doctor_user.inbox.reload.unread_messages_count })
      end
    end

    context 'when the viewer of the message is not a doctor' do
      it 'does not change the message or the unread count' do
        expect do
          described_class.new(message, 'patient').call
        end.to not_change { message.reload.read }
          .and(not_change { default_doctor_user.inbox.reload.unread_messages_count })
      end
    end
  end
end

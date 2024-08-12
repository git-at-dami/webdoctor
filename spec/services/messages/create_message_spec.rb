# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::CreateMessage, type: :transaction do
  let!(:default_patient_user) { create(:user) }
  let!(:default_doctor_user) { create(:user, is_doctor: true, is_patient: false) }
  let!(:default_admin_user) { create(:user, is_admin: true, is_patient: false) }

  let(:result) { described_class.new.call(params) }

  describe '#call' do
    context 'with valid params' do
      context 'with invalid parent_message_id' do
        let(:params) { { parent_message_id: nil, body: 'New message', user_type: 'patient' } }

        it 'sends the message to the default admin' do
          expect(result).to be_success
          expect(result.success.inbox).to eq(default_admin_user.inbox)
          expect(result.success.body).to eq('New message')
        end
      end

      context 'with valid parent_message_id' do
        let(:parent_message) { create(:message, outbox: default_doctor_user.outbox, inbox: default_patient_user.inbox) }
        let(:reply_body) { 'Message Reply' }

        context 'when sender is a patient' do
          let(:params) { { parent_message_id: parent_message.id, body: reply_body, user_type: 'patient' } }

          context 'when parent message is older than a week' do
            let(:parent_message) do
              create(:message, outbox: default_doctor_user.outbox, inbox: default_patient_user.inbox,
                               created_at: 8.days.ago)
            end

            it 'sends the message to the default admin' do
              expect(result).to be_success
              expect(result.success.inbox).to eq(default_admin_user.inbox)
              expect(result.success.body).to eq(reply_body)
              expect(result.success.read).to be(false)
            end
          end

          context 'when parent message was sent within the past week' do
            it 'sends the reply to the doctor' do
              expect(result).to be_success
              expect(result.success.inbox).to eq(default_doctor_user.inbox)
              expect(result.success.outbox).to eq(default_patient_user.outbox)
              expect(result.success.body).to eq(reply_body)
              expect(result.success.read).to be(false)
            end

            it 'increments the recipient\'s inbox unread message count' do
              expect do
                expect(result).to be_success
              end.to change { default_doctor_user.inbox.reload.unread_messages_count }.by(1)
            end
          end
        end

        context 'when sender is not a patient' do
          let(:params) { { parent_message_id: parent_message.id, body: reply_body, user_type: 'doctor' } }

          it 'sends the message to the original sender' do
            result = described_class.new.call(params)

            expect(result).to be_success
            expect(result.success.inbox).to eq(default_doctor_user.inbox)
            expect(result.success.outbox).to eq(default_doctor_user.outbox)
            expect(result.success.body).to eq(reply_body)
            expect(result.success.read).to be(false)
          end
        end
      end
    end
  end
end

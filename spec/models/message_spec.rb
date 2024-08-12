# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:inbox) }
    it { is_expected.to belong_to(:outbox) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(500) }
  end

  describe 'default_scope' do
    let!(:older_message) { create(:message, created_at: 1.day.ago) }
    let!(:newer_message) { create(:message) }

    it 'orders messages at default by created_at in descending order' do
      expect(described_class.all).to eq([newer_message, older_message])
    end
  end

  describe '#created_in_past_week?' do
    context 'when created within the past week' do
      let(:message) { create(:message, created_at: Time.zone.now) }

      it 'returns true' do
        expect(message.created_in_past_week?).to be true
      end
    end

    context 'when created more than a week ago' do
      let(:message) { create(:message, created_at: 2.weeks.ago) }

      it 'returns false' do
        expect(message.created_in_past_week?).to be false
      end
    end
  end

  describe '#sender' do
    let(:user) { create(:user) }
    let(:outbox) { create(:outbox, user:) }
    let(:message) { create(:message, outbox:) }

    it 'returns the user associated with the outbox' do
      expect(message.sender).to eq(user)
    end
  end

  describe '#recipient' do
    let(:user) { create(:user) }
    let(:inbox) { create(:inbox, user:) }
    let(:message) { create(:message, inbox:) }

    it 'returns the user associated with the inbox' do
      expect(message.recipient).to eq(user)
    end
  end

  describe '#unread' do
    context 'when the message has been read' do
      let(:message) { create(:message, read: true) }

      it 'returns false' do
        expect(message.unread).to be(false)
      end
    end

    context 'when the message is unread' do
      let(:message) { create(:message, read: false) }

      it 'returns true' do
        expect(message.unread).to be(true)
      end
    end
  end
end

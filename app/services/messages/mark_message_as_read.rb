# frozen_string_literal: true

module Messages
  class MarkMessageAsRead
    def initialize(message, user_type)
      @message = message
      @user_type = user_type
    end

    def call
      ActiveRecord::Base.transaction do
        if @message.unread && recipient.is_doctor && @user_type == 'doctor'
          @message.inbox.decrement_unread_messages_count
          @message.update!(read: true)
        end
      end
    end

    private

    def recipient
      @message.recipient
    end
  end
end

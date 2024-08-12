# frozen_string_literal: true

module Messages
  class CreateMessage
    include Dry::Transaction

    step :find_parent_message
    step :determine_recipient
    step :create_message

    private

    def find_parent_message(params)
      if params[:parent_message_id]
        parent_message = Message.find(params[:parent_message_id])
        Success(params.merge(parent_message:))
      else
        Success(params)
      end
    end

    def determine_recipient(params)
      parent_message = params[:parent_message]
      user_type = params[:user_type]

      recipient = if parent_message.nil?
                    User.default_admin
                  elsif user_type != 'patient'
                    parent_message.sender
                  elsif parent_message&.created_in_past_week?
                    User.default_doctor
                  else
                    User.default_admin
                  end

      Success(params.merge(recipient:))
    end

    def create_message(params)
      message = Message.new(
        inbox: params[:recipient].inbox,
        outbox: User.current(params[:user_type]).outbox,
        body: params[:body]
      )

      if message.save
        params[:recipient].inbox.increment_unread_messages_count if params[:recipient].is_doctor

        Success(message)
      else
        Failure(message)
      end
    end
  end
end

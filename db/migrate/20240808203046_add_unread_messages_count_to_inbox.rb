# frozen_string_literal: true

class AddUnreadMessagesCountToInbox < ActiveRecord::Migration[7.1]
  def change
    add_column :inboxes, :unread_messages_count, :integer, default: 0
  end
end

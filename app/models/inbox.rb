# frozen_string_literal: true

class Inbox < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :nullify

  def increment_unread_messages_count
    Inbox.increment_counter(:unread_messages_count, id)
  end

  def decrement_unread_messages_count
    Inbox.decrement_counter(:unread_messages_count, id)
  end
end

# == Schema Information
#
# Table name: inboxes
#
#  id                    :integer          not null, primary key
#  unread_messages_count :integer          default(0)
#  user_id               :integer
#
# Indexes
#
#  index_inboxes_on_user_id  (user_id)
#

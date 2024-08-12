# frozen_string_literal: true

class Outbox < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
end

# == Schema Information
#
# Table name: outboxes
#
#  id      :integer          not null, primary key
#  user_id :integer
#
# Indexes
#
#  index_outboxes_on_user_id  (user_id)
#

# frozen_string_literal: true

FactoryBot.define do
  factory :outbox do |_outbox|
    user
  end
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

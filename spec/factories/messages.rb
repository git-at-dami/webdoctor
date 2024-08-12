# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    body { Faker::Lorem.sentence }
    inbox
    outbox
  end
end

# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  body       :text
#  read       :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  inbox_id   :integer
#  outbox_id  :integer
#
# Indexes
#
#  index_messages_on_inbox_id   (inbox_id)
#  index_messages_on_outbox_id  (outbox_id)
#

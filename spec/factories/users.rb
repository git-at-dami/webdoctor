# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    after(:create) do |user|
      create(:inbox, user:)
      create(:outbox, user:)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first_name :string
#  is_admin   :boolean          default(FALSE), not null
#  is_doctor  :boolean          default(FALSE), not null
#  is_patient :boolean          default(TRUE), not null
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

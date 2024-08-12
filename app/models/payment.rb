# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

# == Schema Information
#
# Table name: payments
#
#  id      :integer          not null, primary key
#  amount  :decimal(, )
#  user_id :integer
#
# Indexes
#
#  index_payments_on_user_id  (user_id)
#

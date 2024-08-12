# frozen_string_literal: true

class AddAmountToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :amount, :decimal
  end
end

# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_811_092_528) do
  create_table 'inboxes', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'unread_messages_count', default: 0
    t.index ['user_id'], name: 'index_inboxes_on_user_id'
  end

  create_table 'messages', force: :cascade do |t|
    t.text 'body'
    t.integer 'outbox_id'
    t.integer 'inbox_id'
    t.boolean 'read', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['inbox_id'], name: 'index_messages_on_inbox_id'
    t.index ['outbox_id'], name: 'index_messages_on_outbox_id'
  end

  create_table 'outboxes', force: :cascade do |t|
    t.integer 'user_id'
    t.index ['user_id'], name: 'index_outboxes_on_user_id'
  end

  create_table 'payments', force: :cascade do |t|
    t.integer 'user_id'
    t.decimal 'amount'
    t.index ['user_id'], name: 'index_payments_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.boolean 'is_patient', default: true, null: false
    t.boolean 'is_doctor', default: false, null: false
    t.boolean 'is_admin', default: false, null: false
    t.string 'first_name'
    t.string 'last_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end

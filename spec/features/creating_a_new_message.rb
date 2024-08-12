# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Creating a new message', type: :feature do
  let!(:default_patient_user) { create(:user) }
  let!(:default_doctor_user) { create(:user, is_doctor: true, is_patient: false) }
  let!(:default_admin_user) { create(:user, is_admin: true, is_patient: false) }

  before do
    visit root_path
    click_link 'Patient'
  end

  scenario 'with invalid params' do
    create(:message, outbox: default_doctor_user.outbox, inbox: default_patient_user.inbox)

    visit messages_path(user_type: 'patient')

    page.first('.list-group-item').click

    click_link 'Reply'

    fill_in 'message[body]', with: ''
    click_button 'Send Message'

    expect(page).to have_content('invalid message.')
    expect(page).to have_current_path(messages_path(user_type: 'patient'))
  end

  scenario "patient responds to a doctor's note" do
    create(:message, outbox: default_doctor_user.outbox, inbox: default_patient_user.inbox)

    visit messages_path(user_type: 'patient')

    page.first('.list-group-item').click

    click_link 'Reply'

    message_body = 'Hello, doctor!'
    fill_in 'message[body]', with: message_body
    click_button 'Send Message'

    expect(page).to have_current_path(message_path(Message.first, user_type: 'patient'))
    expect(page).to have_content('message sent')
    expect(page).to have_content(message_body)
  end

  scenario 'doctor sends a message to patient' do
    create(:message, outbox: default_patient_user.outbox, inbox: default_doctor_user.inbox)

    visit messages_path(user_type: 'doctor')

    page.first('.list-group-item').click

    click_link 'Reply'

    message_body = 'Hello, patient, from doctor !'
    fill_in 'message[body]', with: message_body
    click_button 'Send Message'

    expect(page).to have_current_path(message_path(Message.first, user_type: 'doctor'))
    expect(page).to have_content('message sent')
    expect(page).to have_content(message_body)
  end

  scenario 'admin sends a message to patient' do
    create(:message, outbox: default_patient_user.outbox, inbox: default_admin_user.inbox)

    visit messages_path(user_type: 'admin')

    page.first('.list-group-item').click

    click_link 'Reply'

    message_body = 'Hello, patient, from admin !'
    fill_in 'message[body]', with: message_body
    click_button 'Send Message'

    expect(page).to have_current_path(message_path(Message.first, user_type: 'admin'))
    expect(page).to have_content('message sent')
    expect(page).to have_content(message_body)
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:first_name) { 'Medi' }
  let(:last_name) { 'Hive' }
  let(:full_name) { 'Medi Hive' }

  let!(:default_patient_user) { create(:user, first_name:, last_name:) }
  let!(:default_doctor_user) { create(:user, is_doctor: true, is_patient: false) }
  let!(:default_admin_user) { create(:user, is_admin: true, is_patient: false) }

  describe 'associations' do
    it { is_expected.to have_one(:inbox).dependent(:destroy) }
    it { is_expected.to have_one(:outbox).dependent(:destroy) }
    it { is_expected.to have_many(:payments).dependent(:destroy) }
  end

  describe 'scopes' do
    it '.patient returns only patients' do
      expect(described_class.patient).to eq([default_patient_user])
    end

    it '.doctor returns only doctors' do
      expect(described_class.doctor).to eq([default_doctor_user])
    end

    it '.admin returns only admins' do
      expect(described_class.admin).to eq([default_admin_user])
    end
  end

  describe 'User.current' do
    it 'returns the default user for that type' do
      User::ACCOUNT_TYPES.each do |user_type|
        expect(described_class.current(user_type).id).to eq(send("default_#{user_type}_user").id)
      end
    end

    it 'returns the default patient when the user type is not in the list of allowed account types' do
      user_type = User::ACCOUNT_TYPES.join
      expect(described_class.current(user_type).id).to eq(default_patient_user.id)
    end
  end

  describe 'User.default_admin' do
    it 'returns the first admin user' do
      expect(described_class.default_admin).to eq(default_admin_user)
    end
  end

  describe 'User.default_doctor' do
    it 'returns the first doctor user' do
      expect(described_class.default_doctor).to eq(default_doctor_user)
    end
  end

  describe '#full_name' do
    it 'returns the full name of the user' do
      expect(default_patient_user.full_name).to eq(full_name)
    end
  end
end

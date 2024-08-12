# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inbox, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:messages).dependent(:nullify) }
  end
end

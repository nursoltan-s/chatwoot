# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:account_id) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:inviter).class_name('User').required(false) }

    it do
      is_expected.to have_many(:assigned_conversations)
        .class_name('Conversation').dependent(:nullify)
    end
    it { is_expected.to have_many(:inbox_members).dependent(:destroy) }
    it { is_expected.to have_many(:assigned_inboxes).through(:inbox_members) }
    it { is_expected.to have_many(:messages) }
  end

  describe 'pubsub_token' do
    let(:user) { create(:user) }

    it 'gets created on object create' do
      obj = user
      expect(obj.pubsub_token).not_to eq(nil)
    end

    it 'does not get updated on object update' do
      obj = user
      old_token = obj.pubsub_token
      obj.update(name: 'test')
      expect(obj.pubsub_token).to eq(old_token)
    end
  end
end

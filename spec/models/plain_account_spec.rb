require 'rails_helper'

RSpec.describe PlainAccount, type: :model do
  before do
    User.destroy_all
    Account.destroy_all
  end

  specify { expect(subject).to respond_to(:email) }

  context 'relations' do
    specify { expect(subject).to respond_to(:user) }
  end

  context 'valid' do
    it 'when #password present and it matches confirmation' do
      account = described_class.new(email: 'foo@bar.com', password: '12345678')
      expect(account).to be_valid
      expect(account.authenticate('12345678')).to eq account
    end
  end

  context 'invalid' do
    it 'when #password_confirmation is blank' do
      expect(described_class.new(password: '12345678', password_confirmation: '')).to be_invalid
    end

    it 'when #password less then 8 characters' do
      expect(described_class.new(password: '123456')).to be_invalid
    end

    it 'when #password more then 16 characters' do
      expect(described_class.new(password: '1234567890'*3)).to be_invalid
    end
  end
end

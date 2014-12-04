require 'rails_helper'

describe Account do
  let(:vk_auth_hash) {
    {
      provider: 'vkontakte',
      uid: '12345',
      current_timezone_offset: 3,
      info: {
        first_name: 'Boris',
        image: 'http://vk.com/image_url',
        urls: {
          'Vkontakte' => 'http://vk.com/foobar'
        }
      },
      extra: {
        raw_info: {
          photo_200_orig: 'http://vk.com/200',
          photo_100: 'http://vk.com/100'
        }
      }
    }
  }

  before do
    User.destroy_all
    Account.destroy_all
  end

  specify { expect(subject).to respond_to(:provider) }
  specify { expect(subject).to respond_to(:uid) }
  specify { expect(subject).to respond_to(:name) }
  specify { expect(subject).to respond_to(:avatar) }
  specify { expect(subject).to respond_to(:avatar_medium) }
  specify { expect(subject).to respond_to(:avatar_original) }
  specify { expect(subject).to respond_to(:social_network_link) }
  specify { expect(subject).to respond_to(:email) }

  context 'relations' do
    specify { expect(subject).to respond_to(:user) }
  end

  context 'by calling' do
    it '.find_or_create_by_auth_hash returns new user (VK based)' do
      expect { described_class.find_or_create_by_auth_hash(vk_auth_hash) }.to change(Account, :count).by 1
    end

    it '.find_or_create_by_auth_hash returns existing user (VK based)' do
      described_class.find_or_create_by_auth_hash(vk_auth_hash)
      expect { described_class.find_or_create_by_auth_hash(vk_auth_hash) }.to change(Account, :count).by 0
    end
  end

  context 'plain account' do
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
end

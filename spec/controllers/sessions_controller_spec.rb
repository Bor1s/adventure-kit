require 'rails_helper'

RSpec.describe SessionsController do
  before :all do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
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
    )

    OmniAuth.config.mock_auth[:gplus] = OmniAuth::AuthHash.new(
      {
        provider: 'gplus',
        uid: '7890',
        current_timezone_offset: 3,
        info: {
          name: 'BOB',
          urls: {'Google+' => 'someurl'}
        },
        extra: {}
      }
    )
  end

  describe 'requesting #authorize' do
    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:vkontakte]
      User.destroy_all
      Account.destroy_all

      user = FactoryGirl.create(:player_with_vk_account)
      sign_in user.accounts.first
    end

    it 'sets up and picks user from warden' do
      get :authorize
      expect(controller.send(:current_user)).to eq User.first
    end

    it 'adds new account to existing user' do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:gplus]
      get :authorize
      expect(controller.send(:current_user).accounts.count).to eq 2
    end

    it 'remains already existing account for existing user' do
      expect { get :authorize }.to change(Account, :count).by(0)
    end
  end

  describe '#authorize with plain authentification' do
    it 'is valid' do
      allow(controller).to receive(:warden) { double('Warden', 'authenticate!' => true, 'authenticated?' => true) }
      post :authorize, {accounts_attributes: {'0' => {email: 'gir@gmail.com', password: '12345678', password_confirmation: '12345678' }}}
      expect(JSON.parse(response.body)).to eq({'redirect_path' => '/events'})
    end
  end
end

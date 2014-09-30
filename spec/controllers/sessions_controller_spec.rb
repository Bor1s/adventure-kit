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

  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:vkontakte] 
    User.destroy_all
    Account.destroy_all
  end

  describe 'requesting #create' do
    it 'makes new user account and user himself' do
      expect { get :create }.to change(User, :count).by(1)
    end

    it 'sets account id to session' do
      get :create
      expect(session[:account_id]).to eq Account.first.id
    end

    it 'adds new account to existing user' do
      player = FactoryGirl.create(:player_with_vk_account)
      session[:account_id] = player.accounts.first.id
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:gplus]
      get :create
      expect(player.accounts.count).to eq 2
    end

    it 'remains already existing account for existing user' do
      player = FactoryGirl.create(:player_with_vk_account)
      session[:account_id] = player.accounts.first.id
      expect { get :create }.to change(Account, :count).by(0)
    end
  end
end

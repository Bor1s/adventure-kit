require 'rails_helper'

describe UsersController do
  before do
    User.destroy_all

    user = FactoryGirl.create(:player_with_vk_account)
    sign_in user.accounts.first
  end

  context 'requesting' do
    it '#index should return status OK' do
      get :index
      expect(response.status).to eq 200
    end
  end
end

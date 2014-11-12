require 'rails_helper'

describe LocationsController do
  before do
    User.destroy_all
    Game.destroy_all
    Location.destroy_all
    FactoryGirl.create_list(:game_with_location, 3)

    user = FactoryGirl.create(:master_with_vk_account)
    sign_in user.accounts.first
  end

  context 'requesting' do
    it '#index via text/html returns locations, current lat and lng' do
      get :index
      expect(assigns[:lat]).to eq 0.0
      expect(assigns[:lng]).to eq 0.0
    end

    it '#index via json returns nearby locations' do
      get :index, {lat: 0.0, lng: 0.0, format: :json}
      expect(JSON.parse(response.body).count).to eq 3
    end
  end

end

require 'rails_helper'

describe EventsController do
  before do
    Game.destroy_all
    Subscription.destroy_all
    User.destroy_all

    user = FactoryGirl.create(:master_with_vk_account)
    sign_in user.accounts.first
  end

  describe 'JSON #index' do
    let(:game) {FactoryGirl.create(:game_with_upcoming_events)}
    it 'returns game events' do
      get :index, { format: :json, game_id: game.id }
      expect(JSON.parse(response.body)).not_to be_empty
    end
  end
end

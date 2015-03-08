require 'rails_helper'

RSpec.describe ClosestEventsService, type: :service do
  before do
    User.destroy_all
    Game.destroy_all
  end

  context '.call' do
    it 'it returns closest events for user' do
      user = FactoryGirl.create(:master_with_vk_account)
      games = FactoryGirl.create_list(:game_with_finished_events, 3)
      closest_games = FactoryGirl.create_list(:game_with_closest_events, 2)
      games.each {|g| g.subscribe(user)}
      closest_games.each {|g| g.subscribe(user)}

      service = described_class.call(user)
      expect(service.count).to eq 2
    end
  end
end

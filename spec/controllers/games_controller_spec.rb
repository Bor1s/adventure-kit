require 'rails_helper'

describe GamesController do
  before do
    Game.destroy_all
    Subscription.destroy_all
    User.destroy_all
    sign_in_user_via_vk(:master)
  end

  context 'requesting' do
    it '#remove_player allows master to reject player from game' do
      game = FactoryGirl.create(:game)
      master = User.first
      player = FactoryGirl.create(:player)

      game.subscribe(master, :master)
      game.subscribe(player)

      delete :remove_player, {id: game.id, user_id: player.id}
      expect(game.reload.players.count).to eq 0
    end

    it '#remove_player do not removes unsubscribed user' do
      game = FactoryGirl.create(:game)
      master = User.first
      player = FactoryGirl.create(:player)

      game.subscribe(master, :master)

      delete :remove_player, {id: game.id, user_id: player.id}
      expect(game.reload.players.count).to eq 0
    end
  end
end

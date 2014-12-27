require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  before do
    Game.destroy_all
    Subscription.destroy_all
    User.destroy_all

    user = FactoryGirl.create(:master_with_vk_account)
    sign_in user.accounts.first
  end

  context 'AJAX' do
    describe 'POST create' do
      it 'accepts step 1' do
        post :create, {format: :json, step: 1, game: {title: 'some title', description: 'desc'}}
        expect(JSON.parse(response.body)['cache_key']).not_to be_empty
      end

      it 'returns validation errors on step 1' do
        expected_result = {'success' => false, 'errors' => {'title' => ['не может быть пустым']}}
        post :create, {format: :json, step: 1, game: {title: '', description: 'desc'}}
        expect(JSON.parse(response.body)).to eq expected_result
      end
    end
  end

  context 'requesting' do
    it '#remove_player allows master to reject player from game' do
      game = FactoryGirl.create(:game)
      master = User.first
      player = FactoryGirl.create(:player_with_vk_account)

      game.subscribe(master, :master)
      game.subscribe(player)

      delete :remove_player, {id: game.id, user_id: player.id}
      expect(game.reload.players.count).to eq 0
    end

    it '#remove_player do not removes unsubscribed user' do
      game = FactoryGirl.create(:game)
      master = User.first
      player = FactoryGirl.create(:player_with_vk_account)

      game.subscribe(master, :master)

      delete :remove_player, {id: game.id, user_id: player.id}
      expect(game.reload.players.count).to eq 0
    end
  end
end

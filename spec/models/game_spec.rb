require 'spec_helper'

describe Game do
  let(:game_with_tags) {FactoryGirl.create(:game_with_tags)}
  let(:solo_game) {FactoryGirl.create(:game_with_tags, players_amount: 1)}
  let(:player) {FactoryGirl.create(:player)}
  let(:master) {FactoryGirl.create(:master)}

  context 'instance should have' do
    it 'title' do
      expect(subject).to respond_to(:title)
    end

    it 'description' do
      expect(subject).to respond_to(:description)
    end

    it 'players_amount' do
      expect(subject).to respond_to(:players_amount)
    end

    it 'finished?' do
      expect(subject).to respond_to(:finished?)
    end
  end

  context 'instance should' do
    it 'has many :events' do
      expect(subject).to respond_to(:events)
    end

    it 'has many :subscriptions' do
      expect(subject).to respond_to(:subscriptions)
    end

    it 'has and belongs to many :tags' do
      expect(subject).to respond_to(:tags)
    end

    it 'has many :comments' do
      expect(subject).to respond_to(:comments)
    end
  end

  context 'by calling' do
    context '#subscribe subscribes user with' do
      it ':player role' do
        expect { game_with_tags.subscribe(player) }.to change(Subscription, :count).by(1)
      end

      it ':master role' do
        expect { game_with_tags.subscribe(master, :master) }.to change(Subscription, :count).by(1)
      end
    end

    it '.by_tag finds game for current tag' do
      expect(Game.by_tag(game_with_tags.tags.first.id)).to include(game_with_tags)
    end

    it '#redeem removes user from subscribers' do
      game_with_tags.subscribe(player)
      expect { game_with_tags.redeem(player) }.to change(Subscription, :count).by(-1)
    end

    it '#master assumes to return master' do
      game_with_tags.subscribe(master, :master)
      expect(game_with_tags.master).to eq master
    end

    it '#players assumes to return players' do
      game_with_tags.subscribe(player)
      expect(game_with_tags.players).to include(player)
    end

    it '#subscribers assumes to return all subscribers' do
      game_with_tags.subscribe(player)
      game_with_tags.subscribe(master, :master)
      expect(game_with_tags.subscribers).to include(player, master)
    end

    it '#subscribed? check if user subscribed' do
      game_with_tags.subscribe(player)
      expect(game_with_tags.subscribed?(player)).to eq true
    end

    it '#subscribed? check user is not subscribed' do
      game_with_tags.subscribe(player)
      expect(game_with_tags.subscribed?(master)).to eq false
    end

    it '#allows_to_take_part? says true if there is a place for a user' do
      game_with_tags.subscribe(player)
      expect(game_with_tags.allows_to_take_part?).to eq true
    end

    it '#allows_to_take_part? says false if there is not place for a user' do
      solo_game.subscribe(player)
      expect(solo_game.allows_to_take_part?).to eq false
    end
  end
end

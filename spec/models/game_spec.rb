require 'rails_helper'

describe Game do
  let(:solo_game) {FactoryGirl.create(:game, players_amount: 1)}
  let(:private_game) {FactoryGirl.create(:game, private_game: true)}
  let(:online_game) {FactoryGirl.create(:game, online_game: true)}
  let(:game) {FactoryGirl.create(:game, players_amount: 3)}
  let(:user) {FactoryGirl.create(:master)}
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

    it 'private_game' do
      expect(subject).to respond_to(:private_game)
    end

    it 'online_game' do
      expect(subject).to respond_to(:online_game)
    end

    it 'online_info' do
      expect(subject).to respond_to(:online_info)
    end
  end

  context 'instance should' do
    it 'has many :events' do
      expect(subject).to respond_to(:events)
    end

    it 'has many :subscriptions' do
      expect(subject).to respond_to(:subscriptions)
    end

    it 'has many :comments' do
      expect(subject).to respond_to(:comments)
    end

    it 'has one :location' do
      expect(subject).to respond_to(:location)
    end
  end

  context 'by calling' do
    context '#subscribe subscribes user' do
      it ':player role' do
        expect { game.subscribe(user) }.to change(Subscription, :count).by(1)
      end

      it ':master role' do
        expect { game.subscribe(user, :master) }.to change(Subscription, :count).by(1)
      end

      it 'when game in private without checking how many places left' do
        expect { private_game.subscribe(user) }.to change(Subscription, :count).by(1)
      end
    end

    it '#redeem removes user from subscribers' do
      game.subscribe(user)
      expect { game.redeem(user) }.to change(Subscription, :count).by(-1)
    end

    it '#master assumes to return master' do
      game.subscribe(user, :master)
      expect(game.master).to eq user
    end

    it '#players assumes to return players' do
      game.subscribe(user)
      expect(game.players).to include(user)
    end

    it '#subscribers assumes to return all subscribers' do
      game.subscribe(user)
      game.subscribe(master, :master)
      expect(game.subscribers).to include(user, master)
    end

    it '#subscribed? check if user subscribed' do
      game.subscribe(user)
      expect(game.subscribed?(user)).to eq true
    end

    it '#subscribed? check user is not subscribed' do
      game.subscribe(user)
      expect(game.subscribed?(master)).to eq false
    end

    it '#allows_to_take_part? says true if there is a place for a user' do
      game.subscribe(user)
      expect(game.allows_to_take_part?).to eq true
    end

    it '#allows_to_take_part? says false if there is not place for a user' do
      solo_game.subscribe(user)
      expect(solo_game.allows_to_take_part?).to eq false
    end
  end
end

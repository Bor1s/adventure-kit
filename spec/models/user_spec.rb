require 'rails_helper'

describe User do
  let(:vk_auth_hash) {
    {uid: '12345',
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
    }}
  }

  before do
    User.destroy_all
    FactoryGirl.create(:master)
    FactoryGirl.create_list(:user, 2)
  end

  specify { expect(subject).to respond_to(:role) }
  specify { expect(subject).to respond_to(:nickname) }
  specify { expect(subject).to respond_to(:timezone) }
  specify { expect(subject).to respond_to(:bio) }

  context 'relations' do
    specify { expect(subject).to respond_to(:subscriptions) }
    specify { expect(subject).to respond_to(:comments) }
    specify { expect(subject).to respond_to(:accounts) }
    specify { expect(subject).to respond_to(:plain_account) }
  end

  context 'by calling' do
    it '#admin? returns true if user is an admin' do
      user = FactoryGirl.create(:admin)
      expect(user.admin?).to eq true
    end

    it '#creator? returns true if user is the master of the current game' do
      master = described_class.first
      game = FactoryGirl.create(:game)
      game.subscribe(master, :master)
      expect(master.creator?(game)).to eq true
    end

    it '#creator? returns false if user is not the master of the current game' do
      player = described_class.first
      game = FactoryGirl.create(:game)
      expect(player.creator?(game)).to eq false
    end

    it '#mastered_subscriptions returns all subscriptions where user is master' do
      master = described_class.first
      game = FactoryGirl.create(:game)
      game.subscribe(master, :master)
      expect(master.mastered_subscriptions.count).to eq 1
    end

    it "#games returns all user's games" do
      master = described_class.first
      game = FactoryGirl.create(:game)
      game.subscribe(master, :master)
      expect(master.games.count).to eq 1
    end

    it '#has_vk_account? returns true' do
      user = FactoryGirl.create(:master_with_vk_account)
      expect(user.has_vk_account?).to eq true
    end

    it '#has_gplus_account? returns true' do
      user = FactoryGirl.create(:master_with_gplus_account)
      expect(user.has_gplus_account?).to eq true
    end

  end
end

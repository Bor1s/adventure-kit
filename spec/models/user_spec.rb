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
    FactoryGirl.create_list(:player, 2)
  end

  specify { expect(subject).to respond_to(:uid) }
  specify { expect(subject).to respond_to(:name) }
  specify { expect(subject).to respond_to(:role) }
  specify { expect(subject).to respond_to(:email) }
  specify { expect(subject).to respond_to(:avatar) }
  specify { expect(subject).to respond_to(:avatar_medium) }
  specify { expect(subject).to respond_to(:avatar_original) }
  specify { expect(subject).to respond_to(:want_to_be_master) }
  specify { expect(subject).to respond_to(:social_network_link) }
  specify { expect(subject).to respond_to(:current_timezone_offset) }

  context 'relations' do
    specify { expect(subject).to respond_to(:tags) }
    specify { expect(subject).to respond_to(:subscriptions) }
    specify { expect(subject).to respond_to(:comments) }
  end

  context 'by calling' do
    it ':masters scope returns only masters' do
      expect(described_class.masters.count).to eq 1
    end

    it ':players scope returns only players' do
      expect(described_class.players.count).to eq 2
    end

    it ':recent scope returns users created 2 days ago as most' do
      expect(described_class.recent.count).to eq 3
    end

    it '.find_or_create_by_auth_hash returns new user (VK based)' do
      expect { described_class.find_or_create_by_auth_hash(vk_auth_hash) }.to change(User, :count).by 1
    end

    it '.find_or_create_by_auth_hash returns existing user (VK based)' do
      described_class.find_or_create_by_auth_hash(vk_auth_hash)
      expect { described_class.find_or_create_by_auth_hash(vk_auth_hash) }.to change(User, :count).by 0
    end

    it '#master? returns true if user is a master' do
      user = described_class.masters.first
      expect(user.master?).to eq true
    end

    it '#player? returns true if user is a player' do
      user = described_class.players.first
      expect(user.player?).to eq true
    end

    it '#admin? returns true if user is an admin' do
      user = FactoryGirl.create(:admin)
      expect(user.admin?).to eq true
    end

    it '#human_role returns string with role' do
      master = described_class.masters.first
      player = described_class.players.first
      admin  = FactoryGirl.create(:admin)
      expect(master.human_role).to eq 'master'
      expect(player.human_role).to eq 'player'
      expect(admin.human_role).to eq 'admin'
    end

    it '#creator? returns true if user is the master of the current game' do
      master = described_class.masters.first
      game = FactoryGirl.create(:game)
      game.subscribe(master, :master)
      expect(master.creator?(game)).to eq true
    end

    it '#creator? returns false if user is not the master of the current game' do
      player = described_class.players.first
      game = FactoryGirl.create(:game)
      expect(player.creator?(game)).to eq false
    end

    it '#commenter? returns true if user is author of the current comment' do
      player = described_class.players.first
      comment = FactoryGirl.create(:comment, user: player)
      expect(player.commenter?(comment)).to eq true
    end

    it '#commenter? returns false if user is not an author of the current comment' do
      player = described_class.players.first
      comment = FactoryGirl.create(:comment)
      expect(player.commenter?(comment)).to eq false
    end

    it '#mastered_subscriptions returns all subscriptions where user is master' do
      master = described_class.masters.first
      game = FactoryGirl.create(:game)
      game.subscribe(master, :master)
      expect(master.mastered_subscriptions.count).to eq 1
    end

    it "#games returns all user's games" do
      master = described_class.masters.first
      game = FactoryGirl.create(:game)
      game.subscribe(master, :master)
      expect(master.games.count).to eq 1
    end

    it '.search finds users by name' do
      described_class.find_or_create_by_auth_hash(vk_auth_hash)
      expect(described_class.search('boris').count).to eq 1
    end

    it '.search returns empty result' do
      described_class.find_or_create_by_auth_hash(vk_auth_hash)
      expect(described_class.search('John Snow').count).to eq 0
    end
  end
end

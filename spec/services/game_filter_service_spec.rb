require 'rails_helper'

describe GameFilterService do
  before :all do
    Game.destroy_all
    FactoryGirl.create_list(:game, 3)
    FactoryGirl.create_list(:game_with_today_events, 2)
    FactoryGirl.create(:game_with_finished_events)

    Kaminari.configure do |config|
      config.default_per_page = 3
    end
  end

  after :all do
    Kaminari.configure do |config|
      config.default_per_page = 15
    end
  end

  context '#filter' do
    it 'by :all returns all events' do
      service = described_class.new(nil, ['all'], double('User'))
      expect(service.filter.count).to eq 6
    end

    it 'by :all returns all paginated events' do
      service = described_class.new(nil, ['all'], double('User'), 2)
      # Need to explicitly call #to_a to count paginated collection.
      # May be Mongoid bug with kaminari
      expect(service.filter.to_a.count).to eq 3
    end

    it 'by :upcoming returns events started from tomorrow' do
      service = described_class.new(nil, ['upcoming'], double('User'))
      expect(service.filter.count).to eq 5
    end

    it 'by :past returns events finished before today' do
      service = described_class.new(nil, ['past'], double('User'))
      expect(service.filter.count).to eq 1
    end
  end
end

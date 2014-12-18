require 'rails_helper'

describe EventFilterService do
  before :all do
    Game.destroy_all
    FactoryGirl.create_list(:game, 3)
    FactoryGirl.create_list(:game_with_today_events, 2)
    FactoryGirl.create(:game_with_finished_events)
  end

  context '#filter' do
    it 'by :all returns all events' do
      service = described_class.new(double('User'), ['all'])
      expect(service.filter.count).to eq 6
    end

    it 'by :upcoming returns events started from tomorrow' do
      service = described_class.new(double('User'), ['upcoming'])
      expect(service.filter.count).to eq 5
    end

    it 'by :past returns events finished before today' do
      service = described_class.new(double('User'), ['past'])
      expect(service.filter.count).to eq 1
    end
  end
end

require 'rails_helper'

describe EventService do
  subject { EventService }

  before :all do
    Game.destroy_all
    FactoryGirl.create_list(:game, 3)
    FactoryGirl.create_list(:game_with_today_events, 2)
    FactoryGirl.create(:game_with_finished_events)
  end

  context 'calling' do
    it 'without parameters returns upcoming events' do
      expect(subject.call.count).to eq 5
    end

    it 'with :q return searched events' do
      allow(EventService).to receive(:search_by_query) { [Game.first.events.first] }
      expect(subject.call(q: 'foobar').count).to eq 1
    end
  end

  context 'with :f' do
    it 'containing :all returns all events' do
      expect(subject.call(f: 'all').count).to eq 6
    end

    it 'containing :today returns events for today' do
      expect(subject.call(f: 'today').count).to eq 2
    end

    it 'containing :upcoming returns events started from tomorrow' do
      expect(subject.call(f: 'upcoming').count).to eq 5
    end

    it 'containing :finished returns events finished before today' do
      expect(subject.call(f: 'finished').count).to eq 1
    end
  end
end

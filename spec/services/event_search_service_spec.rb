require 'rails_helper'

describe EventSearchService do
  before :all do
    Game.destroy_all
    FactoryGirl.create(:game_with_finished_events)
    FactoryGirl.create(:game_with_upcoming_events)
    FactoryGirl.create_list(:game, 3)
  end

  describe '#new' do
    context 'returns good search result when' do
      it 'only events passed' do
        events = Event.upcoming
        service = described_class.new(events)
        expect(service.search.count).to eq 4
      end
      
      it 'only query passed' do
        allow(Event).to receive(:solr) { double(SolrService, search_events: Event.all.map(&:id)) }
        events = Event.upcoming
        service = described_class.new(nil, 'horror game')
        expect(service.search.count).to eq 5
      end

      it 'events and query passed' do
        allow(Event).to receive(:solr) { double(SolrService, search_events: Event.all.map(&:id)) }
        events = Event.upcoming
        service = described_class.new(events, 'horror game')
        expect(service.search.count).to eq 4
      end
    end
  end
end

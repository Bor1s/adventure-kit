class EventSearchService
  attr_reader :query, :page, :events

  def initialize(events=nil, query=nil, page=1)
    @events = events || Game #Event
    @query = query.presence
    @page = page
  end

  def search
    if @query
      event_ids = Game.solr.search_games(query, page: page)
      #event_ids = Event.solr.search_events(query, page: page)
      # using filtered already events
      events.where(:id.in => event_ids).page(page)
    else
      events.page(page)
    end
  end
end

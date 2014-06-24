class EventService
  def self.call(q: nil, f: nil, page: 1)
    if q.present?
      search_by_query(q, page)
    elsif f.present?
      filtered_events(f, page)
    else
      Event.upcoming.page(page)
    end
  end

  private

  def self.search_by_query(string, page)
    event_ids = Event.solr.search_events(string, page: page)
    Event.where(:id.in => event_ids).page(page)
  end

  def self.filtered_events(filter, page)
    case filter
    when 'all'
      Event.asc(:beginning_at).page(page)
    when 'today'
      Event.for_today.page(page)
    when 'upcoming'
      Event.upcoming.page(page)
    when 'finished'
      Event.finished.page(page)
    end
  end
end

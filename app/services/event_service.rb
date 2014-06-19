class EventService
  def self.call(options={})
    page = options[:page].to_i
    if options[:q].present?
      search_by_query(options[:q], page)
    elsif options[:f].present?
      filtered_events(options[:f], page)
    else
      Event.upcoming.page(page)
    end
  end

  private

  def self.search_by_query(string, page)
    event_ids = Event.solr.search_events(string, page: page)
    Event.where(:id.in => event_ids)
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

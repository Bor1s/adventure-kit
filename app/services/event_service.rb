class EventService
  def self.call(options={})
    if options[:q].present?
      search_by_query(options[:q], options[:page].to_i)
    else
      Event.for_month.asc(:beginning_at)
    end
  end

  private

  def self.search_by_query(string, page)
    event_ids = Event.solr.search_events(string, page: page)
    Event.where(:id.in => event_ids)
  end
end

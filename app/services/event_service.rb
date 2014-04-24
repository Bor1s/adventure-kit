class EventService
  def self.call(options={})
    if options[:tag_id].present?
      search_by_tag(options[:tag_id])
    elsif options[:q].present?
      search_by_query(options[:q], options[:page].to_i)
    else
      Event.for_week.asc(:beginning_at)
    end
  end

  private

  def self.search_by_tag(tag_id)
    game_ids = Game.search(tag_id).map(&:id)
    if game_ids.empty?
      []
    else
      Event.for_games(game_ids)
    end
  end

  def self.search_by_query(string, page)
    event_ids = Event.solr.search_events(string, page: page)
    Event.where(:id.in => event_ids)
  end
end

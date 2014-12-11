class EventService
  def self.call(user: nil, q: nil, f: nil, page: 1)
    if q.present?
      search_by_query(q, page)
    elsif f.present?
      filtered_events(user, f, page)
    else
      Event.upcoming.page(page)
    end
  end

  private

  def self.search_by_query(string, page)
    event_ids = Event.solr.search_events(string, page: page)
    Event.where(:id.in => event_ids).page(page)
  end

  def self.filtered_events(user, filter, page)
    criteria = Event.include

    filter.each do |value|
      criteria = case value
      when 'realtime', 'online'
        criteria
      when 'all'
        criteria.asc(:beginning_at)
      when 'my'
        game_ids = user.player_subscriptions.map(&:game_id)
        criteria.for_games(game_ids)
      when 'owned'
        game_ids = user.mastered_subscriptions.map(&:game_id)
        criteria.for_games(game_ids)
      when 'upcoming'
        criteria.upcoming
      when 'past'
        criteria.finished
      end
    end

    criteria.page(page)
  end
end

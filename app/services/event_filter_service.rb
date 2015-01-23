class EventFilterService
  attr_reader :user, :filters

  def initialize(user, filters)
    @user = user
    @filters = filters.presence || []
  end

  def filter
    criteria = Game.all #include

    filters.each do |f|
      criteria = case f
      when 'realtime'
        criteria.where(online_game: false)
      when 'online'
        criteria.where(online_game: true)
      when 'my'
        game_ids = user.subscriptions.map(&:game_id)
        criteria.where(:id.in => game_ids)
        #criteria.for_games(game_ids)
      when 'upcoming'
        #criteria.upcoming
        event_game_ids = Event.upcoming.map(&:game_id)
        game_ids = criteria.map(&:id)
        intersect_ids = event_game_ids & game_ids
        criteria.where(:id.in => intersect_ids)
      when 'past'
        #criteria.finished
        event_game_ids = Event.finished.map(&:game_id)
        game_ids = criteria.map(&:id)
        intersect_ids = event_game_ids & game_ids
        criteria.where(:id.in => intersect_ids)
      else
        criteria.asc(:created_at)
      end
    end


    criteria
  end
end

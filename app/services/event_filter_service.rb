class EventFilterService
  attr_reader :user, :filters

  def initialize(user, filters)
    @user = user
    @filters = filters.presence || []
  end

  def filter
    criteria = Event.include

    filters.each do |f|
      criteria = case f
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

    criteria
  end
end

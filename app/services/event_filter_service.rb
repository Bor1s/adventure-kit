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
      when 'realtime'
        criteria.where(online: false)
      when 'online'
        criteria.where(online: true)
      when 'my'
        game_ids = user.subscriptions.map(&:game_id)
        criteria.for_games(game_ids)
      when 'upcoming'
        criteria.upcoming
      when 'past'
        criteria.finished
      else
        criteria.asc(:beginning_at)
      end
    end

    criteria
  end
end

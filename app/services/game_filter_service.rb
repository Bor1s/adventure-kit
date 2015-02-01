class GameFilterService
  attr_reader :user, :query, :filters

  def initialize(query, filters, user)
    @query = query.presence
    @user = user
    @filters = filters.presence || []
  end

  def filter
    games_ids = Game.solr.search_games(query)
    criteria = Game.all

    result_ids = []
    my_ids = []
    upcoming_ids = []
    past_ids = []

    filters.each do |f|
      case f
      when 'realtime'
        criteria = criteria.where(online_game: false)
      when 'online'
        criteria = criteria.where(online_game: true)
      when 'my'
        my_ids = user.subscriptions.map(&:game_id)
      when 'upcoming'
        upcoming_ids = Event.upcoming.map(&:game_id)
      when 'past'
        past_ids = Event.finished.map(&:game_id)
      else
        criteria = criteria.asc(:created_at)
      end
    end

    result_ids = combine_ids(games_ids, my_ids, upcoming_ids, past_ids)

    #If nil is returned then we none of IDs criteria is triggered
    if result_ids.nil?
      criteria
    else
      criteria.where(:id.in => result_ids)
    end
  end

  private

  def combine_ids(base_ids, my_ids, upcoming_ids, past_ids)
    if my? and !past? and !upcoming?
      return base_ids & my_ids if with_search?
      return my_ids 
    end
    
    if my? and upcoming?
      return base_ids & my_ids & upcoming_ids if with_search?
      return my_ids & upcoming_ids 
    end
    
    if my? and past?
      return base_ids & my_ids & past_ids if with_search?
      return my_ids & past_ids 
    end

    if !my?
      return base_ids & upcoming_ids if with_search? and upcoming?
      return base_ids & past_ids if with_search? and past?
      return base_ids if with_search?

      return upcoming_ids if upcoming?
      return past_ids if past?
    end

    #Returns nil if none of conditions satisfied
  end

  def realtime?
    filters.include?('realtime')
  end

  def online?
    filters.include?('online')
  end

  def my?
    filters.include?('my')
  end

  def upcoming?
    filters.include?('upcoming')
  end

  def past?
    filters.include?('past')
  end

  def with_search?
    query.present?
  end

end

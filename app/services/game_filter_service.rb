class GameFilterService
  attr_reader :user, :query, :filters, :page

  def initialize(query, filters, user, page=1)
    @query = query.presence
    @user = user
    @filters = filters.presence || []
    @page = page
  end

  def filter
    search_ids = Game.solr.search_games(query)
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

    result_ids = combine_ids(search_ids, my_ids, upcoming_ids, past_ids)

    #If nil is returned then none of IDs criteria is triggered
    if result_ids.nil?
      criteria.asc(:created_at).page(page)
    else
      criteria.asc(:created_at).where(:id.in => result_ids).page(page)
    end
  end

  private

  def combine_ids(search_ids, my_ids, upcoming_ids, past_ids)
    if my? and !past? and !upcoming?
      return search_ids & my_ids if with_search?
      return my_ids 
    end
    
    if my? and upcoming?
      return search_ids & my_ids & upcoming_ids if with_search?
      return my_ids & upcoming_ids 
    end
    
    if my? and past?
      return search_ids & my_ids & past_ids if with_search?
      return my_ids & past_ids 
    end

    if !my?
      return search_ids & upcoming_ids if with_search? and upcoming?
      return search_ids & past_ids if with_search? and past?
      return search_ids if with_search?

      return upcoming_ids if upcoming?
      return past_ids if past?
    end

    #Returns nil if none of upper conditions satisfied
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

class UserSearchService
  def self.call(q: nil, f: nil, page: 1)
    if q.present?
      User.search(q).asc(:created_at).page(page)
    elsif f.present?
      filtered_users(filter: f, page: page)
    else
      filtered_users(page: page)
    end
  end

  private
  
  def self.filtered_users(filter: 'all', page: 1)
    case filter
    when 'all'
      User.asc(:created_at).page(page)
    when 'masters'
      User.masters.asc(:created_at).page(page)
    when 'players'
      User.players.asc(:created_at).page(page)
    end
  end
end

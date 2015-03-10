class UserFilterService
  attr_reader :query, :page

  def initialize(query, page=1)
    @query = query.presence
    @page = page
  end

  def filter
    search_ids = User.solr.search_users(query)
    criteria = User.all

    if query
      criteria.asc(:created_at).where(:id.in => search_ids).page(page).per(50)
    else
      criteria.asc(:created_at).page(page).per(50)
    end
  end
end

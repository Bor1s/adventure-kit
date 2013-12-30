class Genre < Tag
  field :title, type: String
  field :description, type: String

  validates :title, presence: true

  def self.tokenize
    all.map do |g|
      {id: g.id.to_s, title: g.title}
    end
  end

  def self.search string=nil
    if string.present?
      payload = Regexp.escape(string)
      where(title: /#{payload}/i)
    else
      all
    end
  end
end

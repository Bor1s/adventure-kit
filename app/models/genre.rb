class Genre
  include Mongoid::Document

  field :title, type: String
  field :description, type: String

  has_and_belongs_to_many :users

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

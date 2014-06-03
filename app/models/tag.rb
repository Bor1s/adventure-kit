class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String

  has_and_belongs_to_many :users
  has_and_belongs_to_many :games

  validates :title, presence: true, uniqueness: true
  validates_with TagValidator

  def self.tokenize
    all.map do |g|
      {id: g.id.to_s, text: g.title}
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

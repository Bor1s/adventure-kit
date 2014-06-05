class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :last_edited_by, type: BSON::ObjectId

  has_and_belongs_to_many :users
  has_and_belongs_to_many :games

  validates :title, presence: true, uniqueness: true
  validates_with TagValidator

  before_validation :downcase_title

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

  def editor
    User.find(last_edited_by) if last_edited_by.present?
  end

  private

  def downcase_title
    self.title = self.title.downcase
  end
end

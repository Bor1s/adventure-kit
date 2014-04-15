class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  field :description, type: String
  field :beginning_at, type: DateTime

  mount_uploader :poster, PosterUploader

  belongs_to :game

  validates :description, presence: true
  validates :beginning_at, presence: true

  scope :for_week, -> { where(:beginning_at.gte => Time.now.beginning_of_day, :beginning_at.lte => (Time.now + 7.days)) }
  scope :for_games, ->(game_ids) {
    if game_ids.present?
      where(:game_id.in => game_ids)
    else
      all
    end
  }
end

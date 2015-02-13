class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Notification

  field :beginning_at, type: DateTime

  belongs_to :game

  validates :beginning_at, presence: true

  #NOTE Scopes uses additional sum for utc_offset because of Mongoid bug
  scope :upcoming, -> {
    where(:beginning_at.gte => (Time.zone.now + Time.zone.now.utc_offset),
          :beginning_at.lte => (Time.zone.now + 1.month).beginning_of_day).asc(:beginning_at)
  }

  scope :finished, -> {
    where(:beginning_at.lte => (Time.zone.now + Time.zone.now.utc_offset)).asc(:beginning_at)
  }
end

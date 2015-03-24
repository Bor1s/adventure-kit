class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :beginning_at, type: DateTime

  belongs_to :game

  validates :beginning_at, presence: true

  #NOTE Scopes uses additional sum for utc_offset because of Mongoid bug
  scope :upcoming, -> {
    where(:beginning_at.gte => Time.zone.now).asc(:beginning_at)
  }

  scope :finished, -> {
    where(:beginning_at.lte => Time.zone.now).asc(:beginning_at)
  }

  scope :closest, -> {
    where(:beginning_at.gte => Time.zone.now, :beginning_at.lte => Time.zone.now.tomorrow.end_of_day).asc(:beginning_at)
  }
end

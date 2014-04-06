class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  field :description, type: String

  mount_uploader :poster, PosterUploader

  belongs_to :game

  validates :description, presence: true
end

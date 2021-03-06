class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String

  validates :message, presence: true

  belongs_to :game
  belongs_to :user
end

class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :finished, type: Mongoid::Boolean, default: false

  has_many :subscriptions, dependent: :delete
  has_and_belongs_to_many :genres
  has_many :comments, dependent: :delete

  validates :title, presence: true
  validates :description, presence: true

  scope :finished, ->() { where(finished: true) }
  scope :pending, ->() { where(finished: false) }

  def subscribe user, role=:player
    unless subscribed? user
      subscriptions.create!(user_id: user.id, user_right: Subscription::RIGHTS[role])
    end
  end

  def redeem user
    _subscription = subscriptions.where(user_id: user.id).first
    subscriptions.delete _subscription
  end

  def master
    _owner = subscriptions.where(user_right: Subscription::RIGHTS[:master]).first
    _owner &&= _owner.user
  end

  def players
    User.where :id.in => subscriptions.map(&:user_id)
  end

  def subscribed? user
    subscriptions.where(user_id: user.id).first.present?
  end
end

class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :finished, type: Mongoid::Boolean, default: false

  has_many :subscriptions, dependent: :delete
  has_and_belongs_to_many :tags
  has_many :comments, dependent: :delete
  has_many :events, dependent: :destroy #Need to affect Solr index

  validates :title, presence: true
  validates :description, presence: true
  validates :events, presence: true

  scope :finished, ->() { where(finished: true) }
  scope :pending, ->() { where(finished: false) }
  scope :by_tag, ->(tag_id) { where(:tag_ids.in => [tag_id]) }

  accepts_nested_attributes_for :events, allow_destroy: true

  # Force Solr to reindex
  after_update do
    events.each do |e|
      e.class.solr.delete(e.id.to_s)
      e.class.solr.add(e.solr_index_data(title: self.title))
    end
  end

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
    player_subscriptions = subscriptions.where(user_right: Subscription::RIGHTS[:player])
    User.where :id.in => player_subscriptions.map(&:user_id)
  end

  def subscribers
    User.where :id.in => subscriptions.map(&:user_id)
  end

  def subscribed? user
    subscriptions.where(user_id: user.id).first.present?
  end
end

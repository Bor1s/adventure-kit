class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include SolrService::MongoidHooks

  field :title, type: String
  field :description, type: String
  field :players_amount, type: Integer, default: 0
  field :private_game, type: Mongoid::Boolean, default: false
  field :online_game, type: Mongoid::Boolean, default: false
  field :online_info, type: String

  slug :title

  mount_uploader :poster, PosterUploader

  has_many :subscriptions, dependent: :delete
  has_many :comments, dependent: :delete
  has_many :events, dependent: :destroy #Need to affect Solr index
  has_one :location

  accepts_nested_attributes_for :events, allow_destroy: true
  accepts_nested_attributes_for :location

  delegate :lat, to: :location, allow_nil: true
  delegate :lng, to: :location, allow_nil: true

  # Fileds to be indexed by SOLR
  def solr_index_data(options={})
    data = {id: id}
    data[:ctext] = title
    data
  end

  def subscribe user, role=:player
    if private_game?
      unless subscribed? user
        subscriptions.create(user_id: user.id, user_right: Subscription::RIGHTS[role])
      end
    else
      if allows_to_take_part?
        unless subscribed? user
          subscriptions.create(user_id: user.id, user_right: Subscription::RIGHTS[role])
        end
      end
    end
  end

  def redeem user
    _subscription = subscriptions.where(user_id: user.id).first
    subscriptions.delete _subscription if _subscription.present?
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

  def allows_to_take_part?
    players.empty? or (players.count < players_amount)
  end
end

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  ROLES = {admin: 1}

  # General settings to be used in all user's accounts
  field :role, type: Integer, default: ROLES[:player]
  field :want_to_be_master, type: Mongoid::Boolean
  field :timezone, type: String
  field :nickname, type: String
  field :bio, type: String

  mount_uploader :avatar, AvatarUploader

  has_many :accounts, dependent: :delete
  has_one :plain_account, dependent: :delete
  has_many :subscriptions, dependent: :delete
  has_many :comments, dependent: :delete

  accepts_nested_attributes_for :plain_account

  scope :masters, -> { where(:role.in => [1,2]) }
  scope :players, -> { where(role: 3) }
  scope :recent, -> { where(:created_at.gte => (Time.zone.now - 2.days)).desc(:created_at) }

  def admin?
    role == 1
  end

  def creator? game
    subscriptions.where(game_id: game.id, user_right: Subscription::RIGHTS[:master]).first.present?
  end

  def commenter? comment
    comment.user == self
  end

  def player_subscriptions
    subscriptions.where(user_right: Subscription::RIGHTS[:player])
  end

  def mastered_subscriptions
    subscriptions.where(user_right: Subscription::RIGHTS[:master])
  end

  def games
    if subscriptions.exists?
      Game.where(:id.in => subscriptions.map(&:game_id))
    else
      []
    end
  end

  #TODO write specs
  def has_vk_account?
    accounts.where(provider: 'vkontakte').exists?
  end

  def has_gplus_account?
    accounts.where(provider: 'gplus').exists?
  end

end

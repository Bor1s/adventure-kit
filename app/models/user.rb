class User
  include Mongoid::Document
  include Mongoid::Timestamps
  ROLES = {admin: 1}

  # General settings to be used in all user's accounts
  field :role, type: Integer, default: ROLES[:player]
  field :timezone, type: String
  field :nickname, type: String
  field :bio, type: String

  mount_uploader :avatar, AvatarUploader

  has_many :accounts, dependent: :delete
  has_one :plain_account, dependent: :delete
  has_many :subscriptions, dependent: :delete
  has_many :comments, dependent: :delete

  accepts_nested_attributes_for :plain_account

  before_create do
    self.nickname = "user#{rand(10000)}" if self.nickname.blank?
  end

  def admin?
    role == 1
  end

  def creator? game
    subscriptions.where(game_id: game.id, user_right: Subscription::RIGHTS[:master]).first.present?
  end

  def player_subscriptions
    subscriptions.where(user_right: Subscription::RIGHTS[:player])
  end

  def mastered_subscriptions
    subscriptions.where(user_right: Subscription::RIGHTS[:master])
  end

  def games
    Game.where(:id.in => subscriptions.map(&:game_id))
  end

  def has_vk_account?
    accounts.where(provider: 'vkontakte').exists?
  end

  def has_gplus_account?
    accounts.where(provider: 'gplus').exists?
  end

end

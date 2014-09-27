class User
  include Mongoid::Document
  include Mongoid::Timestamps
  ROLES = { admin: 1, master: 2, player: 3}

  # Mandatory fields
  field :email, type: String
  field :role, type: Integer, default: ROLES[:player]
  field :want_to_be_master, type: Mongoid::Boolean
  field :current_timezone_offset, type: Integer, default: 0

  # REMOVE !!!!!!!!! ================
  field :uid, type: String
  field :name, type: String
  field :avatar, type: String
  field :avatar_medium, type: String
  field :avatar_original, type: String
  field :social_network_link, type: String
  # =============================


  has_and_belongs_to_many :tags
  has_many :accounts, dependent: :delete
  has_many :subscriptions, dependent: :delete
  has_many :comments, dependent: :delete

  scope :masters, -> { where(:role.in => [1,2]) }
  scope :players, -> { where(role: 3) }
  scope :recent, -> { where(:created_at.gte => (Time.zone.now - 2.days)).desc(:created_at) }
  scope :by_tag, ->(tag_id) { where(:tag_ids.in => [tag_id]) }

  def admin?
    role == 1
  end

  def master?
    role == 2
  end

  def player?
    role == 3
  end

  def human_role
    if admin?
      'admin'
    elsif master?
      'master'
    else
      'player'
    end
  end

  def creator? game
    subscriptions.where(game_id: game.id, user_right: Subscription::RIGHTS[:master]).first.present?
  end

  def commenter? comment
    comment.user == self
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

end

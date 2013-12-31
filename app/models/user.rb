class User
  include Mongoid::Document
  ROLES = { admin: 1, master: 2, player: 3, god: 777}

  # Mandatory fields
  field :uid, type: String
  field :name, type: String
  field :role, type: Integer, default: ROLES[:player]

  #Additional fields
  field :email, type: String
  field :avatar, type: String
  field :avatar_original, type: String
  field :want_to_be_master, type: Mongoid::Boolean
  field :social_network_link, type: String

  has_and_belongs_to_many :genres
  has_many :approval_boxes, dependent: :delete
  has_many :subscriptions, dependent: :delete

  validates :name, presence: true

  scope :masters, ->() { where(role: 2) }
  scope :players, ->() { where(role: 3) }

  def self.find_or_create_by_auth_hash(auth_hash)
    user = User.where(uid: auth_hash[:uid]).first
    if user
      user.update_attributes(name: auth_hash[:info][:first_name],
                             avatar: auth_hash[:info][:image],
                             avatar_original: auth_hash[:extra][:raw_info][:photo_big],
                             social_network_link: auth_hash[:info][:urls][:Vkontakte])
      user
    else
      User.create(uid: auth_hash[:uid],
                  name: auth_hash[:info][:first_name],
                  avatar: auth_hash[:info][:image],
                  social_network_link: auth_hash[:info][:urls][:Vkontakte])
    end
  end

  def god?
    role == 777
  end

  def admin?
    role == 1
  end

  def master?
    role == 2
  end

  def player?
    role == 3
  end

  def waiting_for_acceptance?
    ApprovalBox.where(user_id: self.id, approved: false).exists?
  end

  def creator? game
    subscriptions.where(game_id: game.id, user_right: Subscription::RIGHTS[:master]).first.present?
  end
end

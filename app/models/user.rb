class User
  ROLES = { admin: 1, master: 2, player: 3 }
  include Mongoid::Document

  # Mandatory fields
  field :uid, type: String
  field :name, type: String
  field :role, type: Integer

  #Additional fields
  field :email, type: String
  field :avatar, type: String

  has_and_belongs_to_many :genres

  validates :name, presence: true

  scope :masters, ->() { where(role: 2) }
  scope :players, ->() { where(role: 3) }

  def self.find_or_create_by_auth_hash(auth_hash)
    user = User.where(uid: auth_hash[:uid]).first
    if user
      user
    else
      User.create(uid: auth_hash[:uid], name: auth_hash[:info][:first_name], avatar: auth_hash[:info][:image])
    end
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
end

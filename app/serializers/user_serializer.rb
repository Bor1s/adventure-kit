class UserSerializer < ActiveModel::Serializer
  has_one :plain_account
  has_many :accounts

  def id
    object.id.to_s
  end

  def has_plain_account
    object.plain_account.present?
  end

  def has_avatar
    object.avatar?
  end

  def stats
    object.games.count
  end

  def url
    Rails.application.routes.url_helpers.user_url(object, only_path: true)
  end

  attributes :id, :nickname, :bio, :has_plain_account, :has_avatar, :avatar, :timezone, :stats, :url
end

class UserSerializer < ActiveModel::Serializer
  has_one :plain_account

  def id
    object.id.to_s
  end

  def has_plain_account
    object.plain_account.present?
  end

  attributes :id, :nickname, :bio, :has_plain_account
end

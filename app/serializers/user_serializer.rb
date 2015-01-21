class UserSerializer < ActiveModel::Serializer
  def id
    object.id.to_s
  end

  attributes :id, :nickname
end

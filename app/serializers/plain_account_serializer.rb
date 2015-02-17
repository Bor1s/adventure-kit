class PlainAccountSerializer < ActiveModel::Serializer

  def id
    object.id.to_s
  end

  attributes :id, :email
end

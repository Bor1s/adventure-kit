class AccountSerializer < ActiveModel::Serializer

  def text
    object.email
  end

  attributes :id, :text
end

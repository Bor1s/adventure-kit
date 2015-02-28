class AccountSerializer < ActiveModel::Serializer
  def provider
    object.provider
  end

  def id
    object.id.to_s
  end

  def social_network_link
    object.social_network_link
  end

  attributes :id, :provider, :social_network_link
end

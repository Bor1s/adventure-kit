class AccountSerializer < ActiveModel::Serializer
  def provider
    object.provider
  end

  def human_provider
    I18n.t("providers.#{object.provider}")
  end

  def id
    object.id.to_s
  end

  def social_network_link
    object.social_network_link
  end

  attributes :id, :provider, :social_network_link, :human_provider
end

class AccountSerializer < ActiveModel::Serializer
  def human_provider
    I18n.t("providers.#{object.provider}")
  end

  def id
    object.id.to_s
  end

  def social_network_link
    object.social_network_link
  end

  def update_url
    Rails.application.routes.url_helpers.master_account_url(object, only_path: true)
  end

  attributes :id, :provider, :social_network_link, :human_provider, :update_url, :open_to_others
end

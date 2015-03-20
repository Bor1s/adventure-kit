class PlainAccountSerializer < ActiveModel::Serializer

  def human_provider
    object.email
  end

  def update_url
    Rails.application.routes.url_helpers.master_account_url(object, only_path: true)
  end

  def id
    object.id.to_s
  end

  attributes :id, :email, :human_provider, :open_to_others, :update_url
end

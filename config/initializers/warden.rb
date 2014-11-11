Rails.application.middleware.insert_after ActionDispatch::Flash, Warden::Manager do |manager|
  manager.default_strategies :oauth
  manager.failure_app = SessionsController.action(:failure)
end

Warden::Manager.serialize_into_session do |user|
  user.id #Means Account
end

Warden::Manager.serialize_from_session do |id|
  Account.find(id)
end

Warden::Strategies.add(:oauth) do

  def authenticate!
    case
    when params['provider'].present?
      send_request_to_oauth_provider(params['provider'])
    when auth_hash.present?
      authorize_user_from_valid_oauth_response(auth_hash)
    when oauth_error?
      fail('OAuth authorization error!')
    else
      fail('WTF?')
    end
  end

  private

  def send_request_to_oauth_provider(unsafe_provider_string)
    provider_name = resolve_provider_name(unsafe_provider_string)
    redirect!("/auth/#{provider_name}")
  end

  def authorize_user_from_valid_oauth_response(auth_hash)
    account = create_user_account(auth_hash)
    success!(account)
  end

  def oauth_error?
    params['error'].present?
  end

  def resolve_provider_name(string)
    return 'vkontakte' if string.match(/vkontakte/)
    return 'gplus' if string.match(/gplus/)
  end

  def auth_hash
    env['omniauth.auth']
  end

  def create_user_account(auth_hash)
    account = Account.find_or_create_by_auth_hash(auth_hash)
    if account.user.blank?
      user = User.create({current_timezone_offset: Time.zone.now.utc_offset})
      user.accounts << account
    end
    account
  end

end

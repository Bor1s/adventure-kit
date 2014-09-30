module ControllersHelper
  def sign_in_user_via_vk(role=:admin_with_vk_account)
    user = FactoryGirl.create(role)
    session[:account_id] = user.accounts.first.id
  end

  def add_account(user, provider_name)
    user.accounts.create(provider: provider_name)
    user.reload
  end
end

RSpec.configure do |config|
  config.include ControllersHelper, type: :controller
end

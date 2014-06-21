module ControllersHelper
  def sign_in_user_via_vk(role=:admin)
    user = FactoryGirl.create(role)
    session[:user_id] = user.id
  end
end

RSpec.configure do |config|
  config.include ControllersHelper, type: :controller
end

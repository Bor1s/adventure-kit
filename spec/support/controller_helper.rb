module ControllersHelper

  def sign_in(user)
    #TODO redo this stuff!
    allow(controller).to receive(:warden) { double('Warden', 'authenticate!' => true, 'authenticated?' => true, user: user) }
  end

  def add_account(user, provider_name)
    user.accounts.create(provider: provider_name)
    user.reload
  end
end

RSpec.configure do |config|
  config.include ControllersHelper, type: :controller
end

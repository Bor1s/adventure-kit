require 'rails_helper'

RSpec.describe GameDashboardController, :type => :controller do
  before do
    User.destroy_all
    user = FactoryGirl.create(:player_with_vk_account)
    sign_in user.accounts.first
  end

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end

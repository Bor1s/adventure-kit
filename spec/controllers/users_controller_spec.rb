require 'rails_helper'

describe UsersController do
  before do
    sign_in_user_via_vk
  end

  context 'requesting' do
    it '#index should return status OK' do
      get :index
      expect(response.status).to eq 200
    end
  end
end

require 'rails_helper'

RSpec.describe RegistrationsController, :type => :controller do
  before do
    allow(controller).to receive(:verfify_not_signed_in) { true }
  end

  context '#new' do
    it 'shows valid page for creating account' do
      get :new
      expect(response.status).to eq 200
    end
  end

  context '#create' do
    it 'accepts valid parameters, creates user and redirects to whatever page' do
      allow_any_instance_of(User).to receive(:save) { true }
      allow(request.env['warden']).to receive(:set_user) { true }
      post :create, {user: {email: 'gir@gmail.com'}}
      expect(response).to redirect_to(root_path)
    end

    it 'renders :new with invalid credentials' do
      allow_any_instance_of(User).to receive(:save) { false }
      post :create, {user: {email: ''}}
      expect(response).to render_template(:new)
    end
  end
end

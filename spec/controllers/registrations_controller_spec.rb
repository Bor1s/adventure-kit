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

  describe '#create' do
    context 'renders success' do
      it 'with valid parameters' do
        allow_any_instance_of(User).to receive(:save) { true }
        allow(request.env['warden']).to receive(:set_user) { true }
        post :create, {user: {plain_account_attributes: {email: 'some@gmail.com', password: '12345678', password_confirmation: '12345678'}}}
        expect(JSON.parse(response.body)).to eq({'success' => true})
      end
    end

    context 'renders error' do
      it 'email not provided' do
        post :create, {user: {plain_account_attributes: {email: '', password: '12345678', password_confirmation: '12345678'}}}
        expect(JSON.parse(response.body)['errors']).to include('email')
      end

      it 'password not provided' do
        post :create, {user: {plain_account_attributes: {email: 'boo@boo.com', password: '', password_confirmation: ''}}}
        expect(JSON.parse(response.body)['errors']).to include('password')
      end

      it 'password_confirmation not provided' do
        post :create, {user: {plain_account_attributes: {email: 'boo@boo.com', password: '12345', password_confirmation: ''}}}
        expect(JSON.parse(response.body)['errors']).to include('password_confirmation')
      end
    end
  end
end

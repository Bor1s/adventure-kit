require 'rails_helper'

describe Master::ProfilesController do

  before do
    User.destroy_all
    @user_with_plain_account = FactoryGirl.create(:master_with_plain_account)
    sign_in @user_with_plain_account.plain_account
  end

  describe 'JSON #edit' do
    it 'returns profile object' do
      get :edit, { format: :json }
      expect(JSON.parse(response.body)).to include('user', 'meta')
    end
  end

  describe 'JSON #update' do
    context 'plain account' do
      it 'successfuly updates basic information' do
        user_params = {nickname: 'ZIM', plain_account_attributes: {email: 'new@gmail.com'}, timezone: 'Kyiv', bio: 'bio'}
        put :update, {user: user_params}
        response_data = JSON.parse(response.body)
        expect(response_data).to include('user')
        expect(response_data['user']['bio']).to eq 'bio'
        expect(response_data['user']['timezone']).to eq 'Kyiv'
        expect(response_data['user']['plain_account']['email']).to eq 'new@gmail.com'
      end

      it 'successfuly changes password' do
        user_params = {plain_account_attributes: {password: 'goodpassword', password_confirmation: 'goodpassword'}}
        put :update, {user: user_params}
        response_data = JSON.parse(response.body)
        expect(response_data).to include('user')
        expect(@user_with_plain_account.plain_account.authenticate('goodpassword')).to eq @user_with_plain_account.plain_account
      end

      it 'does not allow to change password if confirmation is invalid' do
        user_params = {plain_account_attributes: {password: 'goodpassword', password_confirmation: 'bad'}}
        put :update, {user: user_params}
        response_data = JSON.parse(response.body)
        expect(response_data).to include('errors')
      end
    end
  end

  describe '#remove_account' do
    it 'renders :edit when name parameter is missing' do
      delete :remove_account, {}
      expect(response.status).to eq 200
    end

    it 'removes VK account' do
      delete :remove_account, {name: 'vkontakte'}
      expect(response.status).to eq 302
    end

    it 'removes GPlus account' do
      add_account(@user_with_plain_account, 'gplus')
      delete :remove_account, {name: 'gplus'}
      expect(response.status).to eq 302
    end

    it 'does not remove last account' do
      delete :remove_account, {name: 'vkontakte'}
      expect(flash[:alert]).to eq 'You cannot delete last account'
      expect(@user_with_plain_account.accounts.count).to eq 1
    end
  end

end

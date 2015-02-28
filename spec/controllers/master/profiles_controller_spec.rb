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

  describe '#accounts' do
    it 'returns account list for current user' do
      @user_with_plain_account.accounts << FactoryGirl.build(:vk, user: @user_with_plain_account)
      get :accounts, {format: :json}
      json_response = JSON.parse(response.body)
      expect(json_response).to include('profiles')
      expect(json_response).to include('meta')
      expect(json_response['profiles'].count).to eq 1
    end
  end

  describe '#remove_account' do
    it 'removes social network account' do
      account = FactoryGirl.build(:vk, user: @user_with_plain_account)
      @user_with_plain_account.accounts << account
      delete :remove_account, {format: :json, id: account.id}
      expect(JSON.parse(response.body)['success']).to be true
    end

    it 'prevents removing last account' do
      user = FactoryGirl.create(:master_with_vk_account)
      delete :remove_account, {format: :json, id: user.accounts.first.id}
      expect(JSON.parse(response.body)['error']).to eq 'you cannot remove last account'
    end
  end
end

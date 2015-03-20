require 'rails_helper'

RSpec.describe Master::AccountsController, type: :controller do
  before do
    User.destroy_all
    @user_with_plain_account = FactoryGirl.create(:master_with_plain_account)
    add_account(@user_with_plain_account, :vkontakte)
    sign_in @user_with_plain_account.plain_account
  end

  context 'JSON' do
    describe 'PUT #update' do
      it 'saves account' do
        account = @user_with_plain_account.accounts.last
        xhr :put, :update, {id: account.id, account: {open_to_others: true}}
        result = JSON.parse(response.body)['account']['open_to_others']
        expect(result).to be true
      end
    end

    describe 'GET #index' do
      it 'returns all accounts' do
        accounts = @user_with_plain_account.accounts
        xhr :get, :index
        result = JSON.parse(response.body)['accounts'].map {|a| a['id']}
        expected_result = accounts.map {|a| a.id.to_s}
        expect(result).to eq expected_result
      end
    end
  end
end

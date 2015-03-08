require 'rails_helper'

RSpec.describe Master::GamesController, type: :controller do
  before do
    User.destroy_all
    @user_with_plain_account = FactoryGirl.create(:master_with_plain_account)
    sign_in @user_with_plain_account.plain_account
  end

  describe 'JSON #games' do
    it 'returns users games' do
      games = FactoryGirl.create_list(:game, 3)
      games.each do |g|
        g.subscribe(@user_with_plain_account)
      end

      xhr :get, :index

      result = JSON.parse(response.body)['games'].map {|g| g['id']}.sort
      expected_result = games.map {|g| g.id.to_s}.sort

      expect(result).to eq expected_result
    end
  end
end

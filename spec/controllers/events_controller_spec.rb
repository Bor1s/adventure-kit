require 'rails_helper'

describe EventsController do
  before do
    Game.destroy_all
    Subscription.destroy_all
    User.destroy_all

    user = FactoryGirl.create(:master_with_vk_account)
    sign_in user.accounts.first

    FactoryGirl.create_list(:game_with_upcoming_events, 3)
    FactoryGirl.create_list(:game_with_finished_events, 2)

    upcoming_games = FactoryGirl.create_list(:game_with_upcoming_events, 1)
    upcoming_games.each do |g|
      g.subscribe user
    end

    finished_games = FactoryGirl.create_list(:game_with_finished_events, 4)
    finished_games.each do |g|
      g.subscribe user, :master
    end
  end

  describe 'GET #index JSON' do
    it 'responds with upcoming events' do
      get :index, {format: :json, f: 'upcoming'}
      expect(JSON.parse(response.body)['events'].count).to eq 4
    end

    it 'responds with past events' do
      get :index, {format: :json, f: 'past'}
      expect(JSON.parse(response.body)['events'].count).to eq 6
    end

    it 'responds with all events' do
      get :index, {format: :json, f: 'all'}
      expect(JSON.parse(response.body)['events'].count).to eq 10
    end

    it 'responds with my events' do
      get :index, {format: :json, f: 'my'}
      expect(JSON.parse(response.body)['events'].count).to eq 1
    end

    it 'responds with events where I am master' do
      get :index, {format: :json, f: 'owned'}
      expect(JSON.parse(response.body)['events'].count).to eq 4
    end

    context 'combination' do
      it 'of upcoming and my works' do
        get :index, {format: :json, f: 'my,upcoming'}
        expect(JSON.parse(response.body)['events'].count).to eq 1
      end

      it 'of past and my works' do
        get :index, {format: :json, f: 'my,past'}
        expect(JSON.parse(response.body)['events'].count).to eq 0
      end

      it 'of past and my works' do
        get :index, {format: :json, f: 'owned,upcoming'}
        expect(JSON.parse(response.body)['events'].count).to eq 0
      end
    end
  end
end

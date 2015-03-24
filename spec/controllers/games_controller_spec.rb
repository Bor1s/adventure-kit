require 'rails_helper'

RSpec.describe GamesController, type: :controller do
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

  context 'AJAX' do
    describe 'POST #create' do
      context 'step 1' do
        it 'successful' do
          post :create, {format: :json, step: 1, game: {title: 'some title', description: 'desc'}}
          expect(JSON.parse(response.body)['cache_key']).not_to be_empty
        end

        it 'returns validation errors' do
          expected_result = {'success' => false, 'errors' => {'title' => ['не может быть пустым']}}
          post :create, {format: :json, step: 1, game: {title: '', description: 'desc'}}
          expect(JSON.parse(response.body)).to eq expected_result
        end
      end

      context 'step 2' do
        it 'successful for public/location_based game' do
          post :create, {format: :json, step: 2,
                         game: {private_game: false, players_amount: 3, online: false, address: 'New York, Central Park'}
          }
          expect(JSON.parse(response.body)['cache_key']).not_to be_empty
          expect(JSON.parse(response.body)['success']).to be true
        end

        it 'players_amount is invalid' do
          expected_result = {'success' => false, 'errors' => {'players_amount' => ['Players amount should be greater then 0']}}
          post :create, {format: :json, step: 2,
                         game: {private_game: false, players_amount: 0, online_game: false, address: 'New York, Central Park'}
          }
          expect(JSON.parse(response.body)).to eq expected_result
        end

        it 'address is invalid' do
          expected_result = {'success' => false, 'errors' => {'address' => [I18n.t('games.errors.address')]}}
          post :create, {format: :json, step: 2,
                         game: {private_game: false, players_amount: 4, online_game: false, address: ''}
          }
          expect(JSON.parse(response.body)).to eq expected_result
        end

        it 'successful for public/online game' do
          post :create, {format: :json, step: 2,
                         game: {private_game: false, players_amount: 3, online_game: true, online_info: 'skype conf'}
          }
          expect(JSON.parse(response.body)['cache_key']).not_to be_empty
          expect(JSON.parse(response.body)['success']).to be true
        end

        it 'online_info is invalid' do
          expected_result = {'success' => false, 'errors' => {'online_info' => [I18n.t('games.errors.online_info')]}}
          post :create, {format: :json, step: 2,
                         game: {private_game: false, players_amount: 4, online_game: true, online_info: ''}
          }
          expect(JSON.parse(response.body)).to eq expected_result
        end

        it 'successful for private/whatever game' do
          post :create, {format: :json, step: 2,
                         game: {private_game: true,
                                invitees: ['ZIM', 'GIR'],
                                players_amount: 3,
                                online_game: false,
                                address: 'New York, Central Park'}
          }
          expect(JSON.parse(response.body)['cache_key']).not_to be_empty
          expect(JSON.parse(response.body)['success']).to be true
        end
      end

      context 'step 3' do
        it 'successful' do
          post :create, {
            format: :json,
            step: 3,
            game: {
              events_attributes: {
                '1' => {
                  beginning_at: Time.now.to_s
                },
                '2' => {
                  beginning_at: Time.now.tomorrow.to_s
                }
              },
              events_ui_ids: ['1', '2']
            }
          }
          expect(JSON.parse(response.body)['cache_key']).not_to be_empty
          expect(JSON.parse(response.body)['success']).to be true
        end

        it 'responds with special formatted errors for invalid beginning_at' do
          expected_result = {'success' => false, 'errors' => {"1"=>["Выберите дату нажав на поле"]}}
          post :create, {
            format: :json,
            step: 3,
            game: {
              events_attributes: {
                '1' => {
                  beginning_at: ''
                },
                '2' => {
                  beginning_at: Time.now.tomorrow.to_s
                }
              },
              events_ui_ids: ['1', '2']
            }
          }
          expect(JSON.parse(response.body)).to eq expected_result
        end
      end

      context 'step 4' do
        it 'successful' do
          allow_any_instance_of(GameBuilderService).to receive(:build).and_return(true)
          allow_any_instance_of(GameBuilderService).to receive(:game).and_return(double(Game, subscribe: true, id: 1, 'private_game?' => false))
          post :create, {format: :json, step: 4, game: {poster: Rack::Test::UploadedFile.new(Rails.root.join('spec','support', 'files', 'image.png'), 'image/png')}}
          expect(JSON.parse(response.body)['cache_key']).not_to be_empty
          expect(JSON.parse(response.body)['success']).to be true
        end

        it 'fails if poster has invalid format' do
          game = FactoryGirl.build(:game_with_bad_poster)
          game.valid? #false
          allow_any_instance_of(GameBuilderService).to receive(:build).and_return(false)
          allow_any_instance_of(GameBuilderService).to receive(:game).and_return(game)
          expected_result = {'success' => false, 'errors' => {'poster' => ['translation missing: ru.errors.messages.extension_white_list_error']}}
          post :create, {format: :json, step: 4, game: {poster: ''}}
          expect(JSON.parse(response.body)).to eq expected_result
        end
      end
    end
  end

  context 'requesting' do
    it '#remove_player allows master to reject player from game' do
      game = FactoryGirl.create(:game)
      master = User.first
      player = FactoryGirl.create(:master_with_vk_account)

      game.subscribe(master, :master)
      game.subscribe(player)

      delete :remove_player, {id: game.id, user_id: player.id}
      expect(game.reload.players.count).to eq 0
    end

    it '#remove_player do not removes unsubscribed user' do
      game = FactoryGirl.create(:game)
      master = User.first
      player = FactoryGirl.create(:master_with_vk_account)

      game.subscribe(master, :master)

      delete :remove_player, {id: game.id, user_id: player.id}
      expect(game.reload.players.count).to eq 0
    end
  end

  describe 'GET #index JSON' do
    it 'responds with upcoming games' do
      get :index, {format: :json, f: 'upcoming'}
      expect(JSON.parse(response.body)['games'].count).to eq 4
    end

    it 'responds with past games' do
      get :index, {format: :json, f: 'past'}
      expect(JSON.parse(response.body)['games'].count).to eq 6
    end

    it 'responds with all games' do
      get :index, {format: :json, f: 'all'}
      expect(JSON.parse(response.body)['games'].count).to eq 10
    end

    it 'responds with my games' do
      get :index, {format: :json, f: 'my'}
      expect(JSON.parse(response.body)['games'].count).to eq 5
    end

    context 'combination' do
      it 'of upcoming and my works' do
        get :index, {format: :json, f: 'my,upcoming'}
        expect(JSON.parse(response.body)['games'].count).to eq 1
      end

      it 'of past and my works' do
        get :index, {format: :json, f: 'my,past'}
        expect(JSON.parse(response.body)['games'].count).to eq 4
      end

      it 'of upcoming and my works' do
        get :index, {format: :json, f: 'my,upcoming'}
        expect(JSON.parse(response.body)['games'].count).to eq 1
      end
    end
  end

  describe 'GET #ics' do
    it 'responds with attached .ics file' do
      game = User.first.games.first
      get :ics, {id: game.id}
      expect(response.content_type).to eq 'text/calendar'
    end
  end
end

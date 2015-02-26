class GamesController < ApplicationController
  layout 'single_panel'
  before_action :authenticate
  respond_to :json, :js, :html

  def index
    authorize! :read, Game

    if params[:game_id].present?
      @game = Game.find(params[:game_id])
    else
      @games = fetch_games(params)
    end

    respond_with do |format|
      format.json do
        render json: @games
      end
    end
  end

  def show
    game = Game.find params[:id]
    authorize! :read, game

    @game = GameDecorator.new(game)
    render layout: 'application'
  end

  def new
    authorize! :create, Game
    @game = Game.new
    @game.events.build
    @game.build_location
  end

  def create
    #TODO refactor after specs
    step = params[:step].to_i
    service = GameWizardService.new(params[:cache_key], step, game_params)
    service.persist_step
    if service.valid?
      if service.last_step?
        builder = GameBuilderService.new(service.cache_key)
        if builder.build
          game = builder.game
          game.subscribe(current_user, :master)
          if game.private_game?
            if builder.invitees.present?
              User.where(:id.in => builder.invitees).to_a.each do |u|
                game.subscribe(u)
              end
            end
          end
          builder.clear_tmp(service.cache_key)
          render json: {success: true, last_step: service.last_step?, cache_key: game.id.to_s}
        else
          render json: {success: false, errors: builder.game.errors}, status: 422
        end
      else
        render json: {success: true, last_step: service.last_step?, cache_key: service.cache_key}
      end
    else
      render json: {success: false, errors: service.errors}, status: 422
    end
  end

  def edit
    @game = Game.find params[:id]
    authorize! :update, @game

    respond_with @game do |format|
      format.html
      format.json do
        render json: @game, meta: {cache_key: @game.id.to_s}
      end
    end
  end

  def destroy
    @game = Game.find params[:id]
    authorize! :destroy, @game
    @game.destroy
    respond_with @game, location: root_path
  end

  def take_part
    @game = Game.find params[:id]
    payload = {game_id: @game.id, user_id: current_user.id}
    notifications.instrument('join_game', payload) do
      CoreNotification.create(message: "#{current_user_profile.name} joined #{@game.title}")
    end

    respond_with @game do |format|
      @game.subscribe current_user
      format.js
      format.html {redirect_to game_path(@game)}
    end
  end

  def unenroll
    @game = Game.find params[:id]
    unless current_user.creator? @game
      @game.redeem current_user
      payload = {game_id: @game.id, user_id: current_user.id}
      notifications.instrument('left_game', payload) do
        CoreNotification.create(message: "#{current_user_profile.name} left #{@game.title}")
      end
    end

    respond_with @game do |format|
      format.js
      format.html {redirect_to game_path(@game)}
    end
  end

  def remove_player
    @game = Game.find(params[:id])
    authorize! :update, @game
    user = User.find(params[:user_id])
    if @game.subscribed?(user)
      @game.redeem(user)
      payload = {game_id: @game.id, user_id: user.id}
      notifications.instrument('player_rejected', payload) do
        CoreNotification.create(message: "#{current_user_profile.name} left #{@game.title}")
      end
    end

    respond_with @game do |format|
      format.js
      format.html {redirect_to game_path(@game)}
    end
  end

  private

  def game_params
    if params[:game].present? and params[:game][:events_attributes].present?
      params[:game].merge!({events_attributes: preprocess_events_attributes})
    end

    params.merge!({game: {events_attributes: {}}}) if params[:game].blank?

    params.require(:game).permit(:title, :description, :players_amount, :private_game, :online_game, :address, :online_info,
                                 :poster, invitees: [], events_attributes: [:beginning_at, :id, :_destroy], events_ui_ids: [])
  end

  def notifications
    ActiveSupport::Notifications
  end

  def preprocess_events_attributes
    result = []
    params[:game][:events_attributes].each_key do |key|
      result << params[:game][:events_attributes][key]
    end
    result
  end

  def fetch_games(params)
    event_filter_service = GameFilterService.new(params[:q], filters, current_user)
    filtered_events = event_filter_service.filter
  end

  def filters
    params[:f].to_s.split(',')
  end
end

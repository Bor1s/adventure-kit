class GamesController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, Game
    @games = Game.desc(:updated_at).all
    respond_with @games
  end

  def show
    @game = Game.find params[:id]
    authorize! :read, @game
  end

  def new
    authorize! :create, Game
    @game = Game.new
  end

  def create
    @game = Game.create normalize_params game_params
    if @game.valid?
      @game.subscribe(current_user, :master)
      payload = {game: @game, user: current_user}
      notifications.instrument('game_created', payload) do
        CoreNotification.create(message: "#{current_user.name} created #{@game.title}")
      end
    end
    respond_with @game
  end

  def edit
    @game = Game.find params[:id]
    authorize! :update, @game
  end

  def update
    @game = Game.find params[:id]
    authorize! :update, @game
    @game.update_attributes normalize_params game_params
    respond_with @game
  end

  def destroy
    @game = Game.find params[:id]
    authorize! :destroy, @game
    @game.destroy
    respond_with @game
  end

  def take_part
    @game = Game.find params[:id]
    payload = {game: @game, user: current_user}
    notifications.instrument('join_game', payload) do
      CoreNotification.create(message: "#{current_user.name} now joining #{@game.title}")
    end
    @game.subscribe current_user
    flash.notice = 'Now you are taking part in this game'
    redirect_to game_path(@game)
  end

  def unenroll
    @game = Game.find params[:id]
    unless current_user.creator? @game
      @game.redeem current_user
      payload = {game: @game, user: current_user}
      notifications.instrument('left_game', payload) do
        CoreNotification.create(message: "#{current_user.name} left #{@game.title}")
      end
      flash.notice = 'You left this game. Bye bye :('
    end
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:title, :description, :tags)
  end

  def normalize_params parameters
    tags = Tag.find parameters[:tags].split(',')
    parameters[:tags] = tags
    parameters
  end

  def notifications
    ActiveSupport::Notifications
  end
end

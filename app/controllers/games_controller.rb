class GamesController < ApplicationController
  before_action :authenticate
  respond_to :html

  before_filter :extract_optional_params, only: [:new]

  def show
    @game = Game.find params[:id]
    @comment = @game.comments.build
    authorize! :read, @game
  end

  def new
    authorize! :create, Game
    @game = Game.new
    @game.events.build(optional_params)
  end

  def create
    @game = Game.create normalize_params(game_params)
    if @game.valid?
      @game.subscribe(current_user, :master)
      payload = {game_id: @game.id, user_id: current_user.id}
      notifications.instrument('game_created', payload) do
        CoreNotification.create(message: "#{current_user.name} created #{@game.title}")
      end
      location = edit_game_path(@game)
    end
    respond_with(@game, location: location)
  end

  def edit
    @game = Game.find params[:id]
    authorize! :update, @game
  end

  def update
    @game = Game.find params[:id]
    authorize! :update, @game
    @game.update_attributes normalize_params game_params
    respond_with @game, location: edit_game_path(@game)
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
      CoreNotification.create(message: "#{current_user.name} now joining #{@game.title}")
    end
    @game.subscribe current_user
    redirect_to game_path(@game)
  end

  def unenroll
    @game = Game.find params[:id]
    unless current_user.creator? @game
      @game.redeem current_user
      payload = {game_id: @game.id, user_id: current_user.id}
      notifications.instrument('left_game', payload) do
        CoreNotification.create(message: "#{current_user.name} left #{@game.title}")
      end
    end
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:title, :description, :tag_ids, events_attributes: [:title, :poster, :poster_cache, :description, :_destroy, :id, :remove_poster, :beginning_at])
  end

  def normalize_params parameters
    tag_ids = parameters[:tag_ids].split(',')
    new_tags_titles, tag_ids = tag_ids.partition { |t| t.ends_with? '_new' }
    parameters[:tag_ids] = tag_ids
    if new_tags_titles.present?
      new_tags = new_tags_titles.map do |title|
        Tag.where(title: title.chomp('_new')).first_or_create
      end
      parameters[:tag_ids] = tag_ids.concat(new_tags.map(&:id))
    end

    parameters
  end

  def notifications
    ActiveSupport::Notifications
  end

  def optional_params
    @optional_params ||= {}
  end

  def extract_optional_params
    if params[:date].present?
      begin
        optional_params.merge!({beginning_at: Date.parse(params[:date])})
      rescue => e
        warn "#{params[:date]} is not parsed properly!"
      end
    end
  end
end

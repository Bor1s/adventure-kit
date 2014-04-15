class EventsController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, [Event, Game]
    service = StatisticsService.new
    @top_games = service.top_games
    @recent_users = User.recent

    @events = EventService.call(tag_id: params[:q])
  end
end

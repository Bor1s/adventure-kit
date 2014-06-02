class EventsController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, Event
    service = StatisticsService.new
    @top_games = service.top_games.take(10)
    @recent_users = User.recent

    @events = EventService.call(q: params[:q], page: params[:page])
  end
end

class EventsController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, Event
    @events = Event.for_week.asc(:beginning_at)
    @recent_users = User.recent
    @top_games = StatisticsService.top_games
  end
end

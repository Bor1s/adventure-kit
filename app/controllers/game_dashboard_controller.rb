class GameDashboardController < ApplicationController
  before_action :authenticate, :set_timezone

  def index
    @upcoming_events = ClosestEventsService.call(current_user)
  end
end

class DashboardController < ApplicationController

  def index
    @recent_users = User.recent
    @top_games = StatisticsService.top_games
  end
end

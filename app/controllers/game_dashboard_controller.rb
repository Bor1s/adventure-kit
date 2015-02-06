class GameDashboardController < ApplicationController
  before_action :authenticate, :set_timezone

  def index
  end
end

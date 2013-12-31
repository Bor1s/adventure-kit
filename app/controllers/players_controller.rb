class PlayersController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, User
    @players = User.players.all
  end
end

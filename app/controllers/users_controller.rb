class UsersController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, User
    @masters = User.masters.asc(:created_at)
    @players = User.players.asc(:created_at)
  end
end

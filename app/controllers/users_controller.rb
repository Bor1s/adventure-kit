class UsersController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, User
    @users = User.asc(:created_at)
  end
end

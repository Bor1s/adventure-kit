class UsersController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    authorize! :read, User
    @users = UserSearchService.call(q: params[:q], f: params[:f], page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
  end
end

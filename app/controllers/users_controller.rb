class UsersController < ApplicationController
  before_action :authenticate
  respond_to :html, :json

  #TODO rework all!
  def index
    authorize! :read, User
    #@users = UserSearchService.call(q: params[:q], f: params[:f], page: params[:page])
    respond_with @users do |format|
      format.html
      format.json do
        users = User.ne(id: current_user.id)
        render json: users
      end
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
  end
end

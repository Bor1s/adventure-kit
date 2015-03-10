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
        if params[:without_me].present?
          users = User.ne(id: current_user.id)
        else
          service = UserFilterService.new(params[:q], params[:page])
          users = service.filter
        end
        can_load_more = users.total_count > (users.limit_value + users.offset_value)
        render json: users, meta: { can_load_more: can_load_more }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
    render layout: 'single_panel'
  end
end

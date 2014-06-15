class Admin::UsersController < Admin::BaseController

  def index
    @users = User.asc(:name)
  end
end

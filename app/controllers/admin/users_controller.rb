class Admin::UsersController < Admin::BaseController

  def index
    @users = User.asc(:nickname)
  end
end

class Admin::ProfilesController < Admin::BaseController
  include UserConcern

  respond_to :html

  def edit
    @profile = current_user
  end

  def update
    super(redirect_path: edit_admin_profile_path)
  end

  def remove_account
    super(redirect_path: edit_admin_profile_path)
  end

end

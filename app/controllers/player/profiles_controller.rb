class Player::ProfilesController < Player::BaseController
  include UserConcern

  def edit
    @profile = current_user
  end

  def update
    if going_to_become_master?
      new_role = User::ROLES[:master]
      redirect_path = edit_master_profile_path
    else
      redirect_path = edit_player_profile_path
    end

    super(redirect_path: redirect_path) do |_params|
      _params[:role] = new_role if new_role.present?
    end
  end

  def remove_account
    super(redirect_path: edit_player_profile_path)
  end

  private

  def going_to_become_master?
    user_params[:want_to_be_master] == '1'
  end
end

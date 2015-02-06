class Master::ProfilesController < Master::BaseController
  include UserConcern

  def edit
    @profile = current_user
    respond_with @profile do |format|
      format.json do
        render json: @profile, meta: {timezones: get_timezones}
      end
    end
  end

  def update
    if going_to_become_player?
      new_role = User::ROLES[:player]
      redirect_path = edit_player_profile_path
    else
      redirect_path = edit_master_profile_path
    end

    super(redirect_path: redirect_path) do |_params|
      _params[:role] = new_role if new_role.present?
    end
  end

  def remove_account
    super(redirect_path: edit_master_profile_path)
  end

  private

  def going_to_become_player?
    user_params[:want_to_be_master] == '0'
  end

  def get_timezones
    ActiveSupport::TimeZone.all.inject([]) do |result, tz|
      result << {system_name: tz.name, human_name: tz.to_s}
    end
  end
end

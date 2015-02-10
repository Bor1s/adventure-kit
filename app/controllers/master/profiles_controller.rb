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
    redirect_path = edit_master_profile_path

    super(redirect_path: redirect_path) do |_params|
      _params[:role] = new_role if new_role.present?
    end
  end

  def remove_account
    super(redirect_path: edit_master_profile_path)
  end

  private

  def get_timezones
    ActiveSupport::TimeZone.all.inject([]) do |result, tz|
      result << {system_name: tz.name, human_name: tz.to_s}
    end
  end
end

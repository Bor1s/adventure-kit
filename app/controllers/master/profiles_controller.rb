class Master::ProfilesController < Master::BaseController
  before_action :authenticate
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

  def accounts
    respond_with do |format|
      format.json do
        accounts = current_user.accounts.ne(provider: nil)
        render json: accounts, meta: {last_account: accounts.count == 1}
      end
    end
  end

  #TODO refactor
  def remove_account
    respond_with do |format|
      format.json do
        if params[:id].present?
          account = current_user.accounts.where(id: params[:id]).first
          if last_account?
            json = {success: false, error: I18n.t('messages.cannot_remove_last_account')}
            status = 422
          else
            if account == current_user_profile
              status = 422
              json = {success: false, error: I18n.t('messages.cannot_remove_current_account')}
            else
              account.destroy
              json = {success: true}
              status = 200
            end
          end
          render json: json, status: status
        end
      end
    end
  end

  private

  def get_timezones
    ActiveSupport::TimeZone.all.inject([]) do |result, tz|
      result << {system_name: tz.name, human_name: tz.to_s}
    end
  end

  def last_account?
    current_user.accounts.count == 1
  end
end

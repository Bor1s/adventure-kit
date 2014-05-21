class ProfilesController < ApplicationController
  before_action :authenticate
  respond_to :html, :js

  def edit
    @profile = current_user
  end

  def update
    @profile = current_user
    normalized_parameters = normalize_params user_params
    if @profile.update_attributes(normalized_parameters)
      redirect_to edit_profile_path
      notify_about_role_changes
    else
      render :edit
    end
  end

  def heatmap
    respond_with @result do |format|
      format.html
      format.js do
        service = GamesHeatmapService.new
        render json: {data: service.data,
                      title: I18n.t('general.games_heatmap'),
                      days: I18n.t('general.day_names'),
                      step: service.x_axis_step}
      end
    end
  end

  def my_games
    game_ids = current_user.subscriptions.map(&:game_id)
    @games = Game.where(:id.in => game_ids || []).all
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :tag_ids, :want_to_be_master)
  end

  def normalize_params parameters
    tag_ids = parameters[:tag_ids].split(',')
    new_tags_titles, tag_ids = tag_ids.partition { |t| t.ends_with? '_new' }
    parameters[:tag_ids] = tag_ids
    if new_tags_titles.present?
      new_tags = new_tags_titles.map do |title|
        Tag.where(title: title.chomp('_new')).first_or_create
      end
      parameters[:tag_ids] = tag_ids.concat(new_tags.map(&:id))
    end

    parameters
  end

  def notify_about_role_changes
    if current_user.player?
      notify_about_master_born
    else
      notify_about_downgrade_to_player
    end
  end

  def notify_about_master_born
    if going_to_become_master?
      ActiveSupport::Notifications.instrument('master_born', {id: current_user.id}) do
        message = "#{current_user.name} want to become a Master."
        CoreNotification.create(message: message)
        ApprovalBox.create(message: message, user_id: current_user.id)
      end
    end
  end

  def notify_about_downgrade_to_player
    if going_to_become_player?
      current_user.update_attribute(:role, User::ROLES[:player])
      ActiveSupport::Notifications.instrument('player_downgrade', {id: current_user.id}) do
        message = "#{current_user.name} downgrades to Player."
        CoreNotification.create(message: message)
      end
    end
  end

  def going_to_become_master?
    !current_user.waiting_for_acceptance? and current_user.player? and user_params[:want_to_be_master] == '1'
  end

  def going_to_become_player?
    current_user.master? and user_params[:want_to_be_master] == '0'
  end

end

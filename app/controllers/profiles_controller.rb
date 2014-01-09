class ProfilesController < ApplicationController
  before_action :authenticate
  respond_to :html

  def edit
    @profile = current_user
  end

  def update
    @profile = current_user
    normalized_parameters = normalize_params user_params
    if @profile.update_attributes(normalized_parameters)
      redirect_to edit_profile_path, notice: 'Done!'
      notify_about_role_changes
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :tags, :want_to_be_master)
  end

  def normalize_params parameters
    tags = Tag.find parameters[:tags].split(',')
    parameters[:tags] = tags
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
      payload = {name: current_user.name, email: current_user.email, social_network_link: current_user.social_network_link}
      ActiveSupport::Notifications.instrument('master_born', payload) do
        message = "#{current_user.name} want to become a Master."
        CoreNotification.create(message: message)
        ApprovalBox.create(message: message, user_id: current_user.id)
      end
    end
  end

  def notify_about_downgrade_to_player
    if going_to_become_player?
      current_user.update_attribute(:role, User::ROLES[:player])
      payload = {name: current_user.name, email: current_user.email, social_network_link: current_user.social_network_link}
      ActiveSupport::Notifications.instrument('player_downgrade', payload) do
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

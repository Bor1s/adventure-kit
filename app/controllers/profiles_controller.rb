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
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :genres)
  end

  def normalize_params parameters
    genres = Genre.find parameters[:genres].split(',')
    parameters[:genres] = genres
    parameters
  end
end

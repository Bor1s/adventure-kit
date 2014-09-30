class Master::ProfilesController < Master::BaseController
  include UserConcern

  def edit
    @profile = current_user
  end

  def update
    @profile = current_user
    normalized_parameters = normalize_params user_params
    if @profile.update_attributes(normalized_parameters)
      redirect_to edit_master_profile_path
    else
      render :edit
    end
  end

  def remove_account
    if params[:name].present?
      account = current_user.accounts.where(provider: params[:name]).first
      if last_account?
        flash.alert = 'You cannot delete last account'
      else
        handle_account_in_session(account)
      end
      redirect_to edit_master_profile_path
    else
      render :edit
    end
  end

  private

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

    parameters[:role] = User::ROLES[:player] if going_to_become_player?

    parameters
  end

  def going_to_become_player?
    user_params[:want_to_be_master] == '0'
  end
end

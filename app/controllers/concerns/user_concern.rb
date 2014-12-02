module UserConcern

  def user_params
    params.require(:user).permit(:tag_ids, :want_to_be_master, :avatar, :avatar_cache, :nickname, :remove_avatar)
  end

  def update(redirect_path: root_path, render_path: :edit)
    @profile = current_user
    normalized_parameters = normalize_params(user_params)

    yield(normalized_parameters) if block_given?

    if @profile.update_attributes(normalized_parameters)
      redirect_to redirect_path
    else
      render render_path
    end
  end

  def handle_account_in_session(account)
    #Assigns another user account to session
    if account == current_user_profile
      new_session_account = current_user.accounts.ne(uid: account.uid).first
      session[:account_id] = new_session_account.id
    end
    account.destroy
  end

  def last_account?
    current_user.accounts.count == 1
  end

  def remove_account(render_path: :edit, redirect_path: root_path)
    if params[:name].present?
      account = current_user.accounts.where(provider: params[:name]).first
      if last_account?
        flash.alert = 'You cannot delete last account'
      else
        handle_account_in_session(account)
      end
      redirect_to redirect_path
    else
      render render_path
    end
  end

  private

  def normalize_params(parameters, &block)
    tag_ids = parameters[:tag_ids].split(',')
    new_tags_titles, tag_ids = tag_ids.partition { |t| t.ends_with? '_new' }
    parameters[:tag_ids] = tag_ids
    if new_tags_titles.present?
      new_tags = new_tags_titles.map do |title|
        Tag.where(title: title.chomp('_new')).first_or_create
      end
      parameters[:tag_ids] = tag_ids.concat(new_tags.map(&:id))
    end

    block.call(parameters) if block_given?

    parameters
  end
end

module ApplicationHelper
  def allowed_to_manage_game? game
    [:update, :destroy].any? {|ability| can?(ability, game)}
  end

  def errors_for model
    unless model.errors.empty?
      html =<<-HTML
        <div class='alert alert-danger alert-dismissable'>
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <ul>
            #{model.errors.full_messages.map do |msg|
              content_tag :li, msg
            end.join}
          </ul>
        </div>
      HTML
      html.html_safe
    end
  end

  #TODO rework
  def flash_messages
    unless flash.empty?
      msgs = flash.map {|name, msg| msg}.join(' ')
      html =<<-HTML
        <div class='alert alert-success alert-dismissable'>
          #{msgs}
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        </div>
      HTML
      html.html_safe
    end
  end

  def current_tab? name
    controller_name == name
  end

  def activity(state, default_state)
    'active' if (state == default_state and params[:f].blank?) || (params[:f] == state)
  end

  def path_to_current_user_profile
    case
    when current_user.master?
      edit_master_profile_path
    when current_user.player?
      edit_player_profile_path
    when current_user.admin?
      edit_admin_profile_path
    end
  end
end

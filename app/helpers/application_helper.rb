module ApplicationHelper
  def allowed_to_manage_game? game
    [:update, :destroy].any? {|ability| can?(ability, game)}
  end

  def path_to_current_user_profile
    case
    when current_user.admin?
      edit_admin_profile_path
    else
      edit_master_profile_path
    end
  end

  def will_be_at(game)
    case
    when game.events.any? {|e| e.beginning_at.today? }
      t('general.today')
    else
      t('general.tomorrow')
    end
  end
end

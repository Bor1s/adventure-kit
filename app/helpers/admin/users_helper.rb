module Admin::UsersHelper
  def row_indicator_class(game)
    if game.events.last.beginning_at.past?
      'active'
    elsif game.events.last.beginning_at.today?
      'danger'
    elsif game.places_left.zero?
      'success'
    end
  end
end

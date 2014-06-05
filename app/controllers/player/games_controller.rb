class Player::GamesController < Player::BaseController

  def index
    game_ids = current_user.subscriptions.map(&:game_id)
    @games = Game.where(:id.in => game_ids || []).all
  end
end

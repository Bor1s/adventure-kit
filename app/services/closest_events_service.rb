class ClosestEventsService
  def self.call(user)
    user_games_ids = user.games.map(&:id)
    games_ids = Event.closest.where(:game_id.in => user_games_ids).map(&:game_id)
    user.games.where(:id.in => games_ids)
  end
end

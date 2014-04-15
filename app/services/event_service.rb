class EventService
  def self.call(options={})
    tag_id = options[:tag_id]
    game_ids = Game.search(tag_id).map(&:id)
    if game_ids.empty?
      []
    else
      Event.for_games(game_ids).for_week.asc(:beginning_at)
    end
  end
end

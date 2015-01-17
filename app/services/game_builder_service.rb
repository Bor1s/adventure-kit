class GameBuilderService
  EXISTING_GAME_PREFIX = 'new_game_'
  attr_reader :game, :game_cache_key, :game_id, :data

  def initialize(game_cache_key)
    @game_cache_key = game_cache_key
    @game_id = cache_key_to_id(game_cache_key)
    @data = Sidekiq.redis do |conn|
      conn.hgetall game_cache_key
    end
  end

  def build
    _game = game_id.present? ? Game.find(game_id) : Game.new
    persist(_game, data)
  end

  def clear_tmp(key)
    clear_tmp_data(key)
    clear_tmp_poster(data['poster_url'])
  end

  private

  def cache_key_to_id(key)
    key.starts_with?(EXISTING_GAME_PREFIX) ? nil : key
  end

  def persist(object, data)
    @game = object
    @game.title = data['title']
    @game.description = data['description']
    @game.online_game = data['online_game']
    if @game.online_game?
      @game.online_info = data['online_info']
    else
      @game.location_attributes = {address: data['address']}
    end
    @game.private_game = data['private_game']
    if @game.private_game?
      #Invite users by data['invitees']
    else
      @game.players_amount = data['players_amount'].to_i
    end
    @game.events_attributes = JSON.parse(data['events_attributes'])
    @game.poster = File.open(data['poster_url']) if data['poster_url']

    @game.save
  end

  def clear_tmp_data(key)
    Sidekiq.redis do |conn|
      conn.del key
    end
  end

  def clear_tmp_poster(tmp_file_path)
    if tmp_file_path.present? and File.exists?(tmp_file_path)
      File.delete(tmp_file_path)
    end
  end
end

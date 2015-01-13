class GameBuilderService
  EXISTING_GAME_PREFIX = 'new_game_'
  attr_reader :game_cache_key, :creator, :game_id, :data

  def initialize(game_cache_key, creator)
    @game_cache_key = game_cache_key
    @creator = creator
    @game_id = cache_key_to_id(game_cache_key)
    @data = Sidekiq.redis do |conn|
      conn.hgetall game_cache_key
    end
  end

  def build
    if game_id.present?
      edit_game(game_id, data, creator)
    else
      create_game(data, creator)
    end
  end

  private

  def cache_key_to_id(key)
    key.starts_with?(EXISTING_GAME_PREFIX) ? nil : key
  end

  def create_game(data, creator)
    game = Game.new
    game.title = data['title']
    game.description = data['description']
    game.online_game = data['online_game']
    if game.online_game?
      game.online_info = data['online_info']
    else
      game.location_attributes = {address: data['address']}
    end
    game.private_game = data['private_game']
    if game.private_game?
      #Invite users by data['invitees']
    else
      game.players_amount = data['players_amount'].to_i
    end
    game.events_attributes = JSON.parse(data['events_attributes'])
    game.poster = File.open(data['poster_url']) if data['poster_url']
    game.save!
    game.subscribe(creator, :master)

    #Clear tmp data
    clear_tmp_data(game_cache_key, data['poster_url'])

    game.id
  end

  def edit_game(id, data, creator)
    game = Game.find(id)
    game.title = data['title']
    game.description = data['description']
    game.online_game = data['online_game']
    if game.online_game?
      game.online_info = data['online_info']
    else
      game.location_attributes = {address: data['address']}
    end
    game.private_game = data['private_game']
    if game.private_game?
      #Invite users by data['invitees']
    else
      game.players_amount = data['players_amount'].to_i
    end
    game.events_attributes = JSON.parse(data['events_attributes'])

    #Manage poster
    game.poster = File.open(data['poster_url']) if data['poster_url']
    game.save!
    game.subscribe(creator, :master)

    #Clear tmp data
    clear_tmp_data(game_cache_key, data['poster_url'])

    game.id
  end

  def clear_tmp_data(key, tmp_file_path)
    #Removes data from Redis
    Sidekiq.redis do |conn|
      conn.del key
    end

    #Removes tmp poster
    if tmp_file_path.present? and File.exists?(tmp_file_path)
      File.delete(tmp_file_path)
    end
  end
end

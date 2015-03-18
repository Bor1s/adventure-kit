class GameDecorator
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def poster
    game.poster
  end

  def id
    game.id
  end

  def title
    game.title
  end

  def description
    game.description
  end

  def next_session
    event = game.events.upcoming.asc(:beginning_at).first
    if event.present?
      event.beginning_at.strftime('%d-%m-%Y %H:%M')
    else
      I18n.t('events.no_future_events')
    end
  end

  def address
    game.location.address if game.location.present?
  end

  def online_info
    game.online_info
  end

  def online_game?
    game.online_game? and game.online_info.present?
  end

  def players
    game.players
  end

  def subscribers
    game.subscribers
  end

  def slug
    game.slug
  end

  def subscribed?(user)
    game.subscribed?(user)
  end

  def private_game?
    game.private_game?
  end

  def allows_to_take_part?
    game.allows_to_take_part?
  end

  def players_amount
    game.players_amount
  end
end

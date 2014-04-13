class CoreNotificator < ActionMailer::Base
  default from: "playhard-core-noreply@gmail.com"

  def master_born payload
    @name = payload[:name]
    @email = payload[:email]
    @social_network_link = payload[:social_network_link]

    mail to: 'boris.bbk@gmail.com', subject: 'Potential Master detected!'
  end

  def player_downgrade payload
    @name = payload[:name]
    @email = payload[:email]
    @social_network_link = payload[:social_network_link]

    mail to: 'boris.bbk@gmail.com', subject: 'Master downgrades to player!'
  end

  def game_created payload
    game = Game.find(payload[:game_id])
    @title = game.title
    @description = game.description
    @game_id = game.id
    mail to: 'boris.bbk@gmail.com', subject: 'New game created'
  end

  def join_game payload
    game = Game.find(payload[:game_id])
    user = User.find(payload[:user_id])
    @user_name = user.name
    @title = game.title
    @game_id = game.id
    mail to: 'boris.bbk@gmail.com', subject: 'Player joins game'
  end

  def left_game payload
    game = Game.find(payload[:game_id])
    user = User.find(payload[:user_id])
    @user_name = user.name
    @title = game.title
    @game_id = game.id
    mail to: 'boris.bbk@gmail.com', subject: 'Player left game'
  end
end

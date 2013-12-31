class CoreNotificator < ActionMailer::Base
  default from: "playhard-core-noreply@gmail.com", cc: 'boris.bbk@gmail.com'

  def master_born payload
    @name = payload[:name]
    @email = payload[:email]
    @social_network_link = payload[:social_network_link]

    mail to: 'mastersergten@gmail.com', subject: 'Potential Master detected!'
  end

  def player_downgrade payload
    @name = payload[:name]
    @email = payload[:email]
    @social_network_link = payload[:social_network_link]

    mail to: 'mastersergten@gmail.com', subject: 'Master downgrades to player!'
  end

  def game_created payload
    @user = payload[:user]
    @game = payload[:game]
    mail to: 'mastersergten@gmail.com', subject: 'New game created'
  end

  def join_game payload
    @user = payload[:user]
    @game = payload[:game]
    mail to: 'mastersergten@gmail.com', subject: 'Player joins game'
  end

  def left_game payload
    @user = payload[:user]
    @game = payload[:game]
    mail to: 'mastersergten@gmail.com', subject: 'Player left game'
  end
end

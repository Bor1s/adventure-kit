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
end

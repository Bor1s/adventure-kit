class CoreNotificator < ActionMailer::Base
  default from: "playhard-core-noreply@gmail.com"

  def master_born payload
    @master = User.find(payload[:id])
    mail to: 'boris.bbk@gmail.com'
  end

  def player_downgrade payload
    @player = User.find(payload[:id])
    mail to: 'boris.bbk@gmail.com'
  end

  def event_created payload
    @event = Event.find(payload[:id])
    @event.game.subscribers.each do |user|
      mail to: user.email if user.email.present?
    end
  end

  def join_game payload
    @game = Game.find(payload[:game_id])
    @subscriber = User.find(payload[:user_id])
    @master = @game.master
    mail to: @master.email if @master.email.present?
  end

  def left_game payload
    @game = Game.find(payload[:game_id])
    @subscriber = User.find(payload[:user_id])
    @master = @game.master
    mail to: @master.email if @master.email.present?
  end
end

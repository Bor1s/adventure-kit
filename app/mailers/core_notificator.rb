class CoreNotificator < ActionMailer::Base
  default from: "playhard-core-noreply@gmail.com"

  def event_created(event_id, user_id)
    @event = Event.find(event_id)
    @user = User.find(user_id)
    mail to: @user.email
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

  def game_is_coming(event_id, user_id)
    @event = Event.where(id: event_id).first
    @user = User.where(id: user_id).first
    @master = @event.game.master
    mail to: @user.email
  end

  def player_rejected(payload)
    @game = Game.find(payload[:game_id])
    @user = User.find(payload[:user_id])
    @master = @game.master
    mail to: @user.email if @user.email.present?
  end
end

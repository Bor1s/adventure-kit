ActiveSupport::Notifications.subscribe('event_created') do |name, start, finish, id, payload|
  @event = Event.find(payload[:id])
  @event.game.subscribers.each do |subscriber|
    #if subscriber.email.present?
      #CoreNotificator.delay.event_created(@event.id, subscriber.id)
    #end
  end
end

ActiveSupport::Notifications.subscribe('join_game') do |name, start, finish, id, payload|
  #CoreNotificator.delay.join_game(payload)
end

ActiveSupport::Notifications.subscribe('left_game') do |name, start, finish, id, payload|
  #CoreNotificator.delay.left_game(payload)
end

ActiveSupport::Notifications.subscribe('player_rejected') do |name, start, finish, id, payload|
  #CoreNotificator.delay.player_rejected(payload)
end

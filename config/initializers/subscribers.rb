ActiveSupport::Notifications.subscribe('master_born') do |name, start, finish, id, payload|
  CoreNotificator.delay.master_born(payload)
end

ActiveSupport::Notifications.subscribe('player_downgrade') do |name, start, finish, id, payload|
  CoreNotificator.delay.player_downgrade(payload)
end

ActiveSupport::Notifications.subscribe('game_created') do |name, start, finish, id, payload|
  CoreNotificator.delay.game_created(payload)
end

ActiveSupport::Notifications.subscribe('join_game') do |name, start, finish, id, payload|
  CoreNotificator.delay.join_game(payload)
end

ActiveSupport::Notifications.subscribe('left_game') do |name, start, finish, id, payload|
  CoreNotificator.delay.left_game(payload)
end

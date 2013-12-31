ActiveSupport::Notifications.subscribe('master_born') do |name, start, finish, id, payload|
  CoreNotificator.master_born(payload).deliver!
end

ActiveSupport::Notifications.subscribe('player_downgrade') do |name, start, finish, id, payload|
  CoreNotificator.player_downgrade(payload).deliver!
end

ActiveSupport::Notifications.subscribe('game_created') do |name, start, finish, id, payload|
  CoreNotificator.game_created(payload).deliver!
end

ActiveSupport::Notifications.subscribe('join_game') do |name, start, finish, id, payload|
  CoreNotificator.join_game(payload).deliver!
end

ActiveSupport::Notifications.subscribe('left_game') do |name, start, finish, id, payload|
  CoreNotificator.left_game(payload).deliver!
end

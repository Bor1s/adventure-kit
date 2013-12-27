ActiveSupport::Notifications.subscribe('master_born') do |name, start, finish, id, payload|
  CoreNotificator.master_born(payload).deliver!
end

ActiveSupport::Notifications.subscribe('player_downgrade') do |name, start, finish, id, payload|
  CoreNotificator.player_downgrade(payload).deliver!
end


namespace :mail_watcher do
  desc 'Checks for upcoming games and alerts participants'
  task check_and_deliver: :environment do
    Event.nearest.each do |event|
      event.game.subscribers.each do |s|
        CoreNotificator.delay.game_is_coming(event.id, s.id)
      end
    end
  end
end


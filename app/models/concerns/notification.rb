module Notification
  def self.included(base)
    base.class_eval do

      after_create do |document|
        if document.game.players.present?
          ActiveSupport::Notifications.instrument('event_created', {id: document.id}) do
            CoreNotification.create(message: "#{document.game.title}: #{document.title} created by #{document.game.master.nickname}")
          end
        end
      end
    end
  end
end

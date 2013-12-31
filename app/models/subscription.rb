class Subscription
  include Mongoid::Document
  RIGHTS = {master: 1, player: 2}

  field :user_right, type: Integer

  belongs_to :user
  belongs_to :game
end

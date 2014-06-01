# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do

    title 'Wake Of The Dead'
    description 'Wake Of The Dead horror game'
    players_amount 3
    events_attributes {[FactoryGirl.attributes_for(:event)]}

    factory :game_with_tags do
      after(:create) do |game, evaluator|
        game.tags.create(attributes_for(:tag))
      end
    end

  end
end

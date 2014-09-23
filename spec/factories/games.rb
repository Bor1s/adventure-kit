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

    factory :game_with_today_events do
      events_attributes {[FactoryGirl.attributes_for(:today_event)]}
    end

    factory :game_with_finished_events do
      events_attributes {[FactoryGirl.attributes_for(:finished_event)]}
    end

    factory :game_with_location do
      after(:create) do |game, evaluator|
        game.create_location(attributes_for(:location))
      end
    end

  end
end

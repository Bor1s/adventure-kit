# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do

    title 'Wake Of The Dead'
    description 'Wake Of The Dead horror game'
    events_attributes {[FactoryGirl.attributes_for(:event)]}

    factory :game_with_today_events do
      events_attributes {[FactoryGirl.attributes_for(:today_event)]}
    end

    factory :game_with_upcoming_events do
      events_attributes {[FactoryGirl.attributes_for(:upcoming_event)]}
    end

    factory :game_with_finished_events do
      events_attributes {[FactoryGirl.attributes_for(:finished_event)]}
    end

    factory :game_with_location do
      after(:create) do |game, evaluator|
        game.create_location(attributes_for(:location))
      end
    end

    factory :game_with_bad_poster do
      poster File.open(Rails.root.join('spec','support', 'files', 'bad_format_poster.xml'))
    end
  end
end

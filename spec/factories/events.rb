# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    beginning_at { Time.now.next_week }

    factory :today_event do
      beginning_at { Time.now + 1.hour }
    end

    factory :upcoming_event do
      beginning_at { Time.now.tomorrow }
    end

    factory :finished_event do
      beginning_at { Time.now.yesterday }
    end

    factory :closest_event do
      beginning_at { Time.now + 3.hours}
    end
  end
end

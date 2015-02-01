# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    beginning_at { Time.now.tomorrow }

    factory :today_event do
      beginning_at { Time.now + 1.hour }
    end

    factory :finished_event do
      beginning_at { Time.now.yesterday }
    end
  end
end

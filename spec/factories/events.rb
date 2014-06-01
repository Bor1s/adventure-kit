# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    sequence :description do |d|
      "Some #{d} description"
    end
    beginning_at { Time.now.tomorrow }
  end
end

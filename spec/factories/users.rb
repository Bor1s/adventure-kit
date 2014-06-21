# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    uid { SecureRandom.hex(16) }

    sequence :name do |n|
      "user_#{n}"
    end

    factory :admin do
      role 1
    end

    factory :master do
      role 2
    end

    factory :player do
      role 3
    end
  end
end

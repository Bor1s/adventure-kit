# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    uid { SecureRandom.hex(16) }
    name 'Boris'

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

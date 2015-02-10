# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    factory :admin do
      role 1
    end

    factory :master do
      role 2
    end

    factory :player do
      role 3
    end

    factory :admin_with_vk_account do
      role 1

      after(:create) do |user, evaluator|
        user.accounts.create(uid: '12345', name: 'GIR', provider: 'vkontakte')
      end
    end

    factory :master_with_vk_account do
      role 2

      after(:create) do |user, evaluator|
        user.accounts.create(uid: '12345', name: 'ZIM', provider: 'vkontakte')
      end
    end
    
    factory :master_with_plain_account do
      after(:create) do |user, evaluator|
        user.create_plain_account(email: Faker::Internet.free_email, password: '12345678', password_confirmation: '12345678')
      end
    end
    
  end
end

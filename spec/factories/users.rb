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

    factory :player_with_vk_account do
      role 3

      after(:create) do |user, evaluator|
        user.accounts.create(uid: '12345', name: 'DIB', provider: 'vkontakte')
      end
    end
  end
end

FactoryGirl.define do
  factory :account do
    factory :vk do
      provider 'vkontakte'
      name Faker::Name.name
      uid { rand(1000) }
    end
  end
end

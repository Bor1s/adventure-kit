FactoryGirl.define do
  factory :tag do
    sequence :title do |t|
      "#{t} tag"
    end
  end
end

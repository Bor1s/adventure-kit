FactoryGirl.define do
  factory :tag do
    sequence :title do |t|
      "#{t}tag"
    end

    description 'Foobar description'
  end
end

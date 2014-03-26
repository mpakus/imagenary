FactoryGirl.define do
  factory :photo do
    comment Faker::Lorem.sentence(5)
    association :user, factory: :user
  end
end
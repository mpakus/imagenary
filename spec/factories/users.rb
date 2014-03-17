FactoryGirl.define do
  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    password '100500'
  end
end
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "test-#{n}@gmail.com"
  end

  sequence :surname do |n|
    "User #{n}"
  end

  factory :user do
    uid "uid"
    name "Test"
    surname { generate(:surname) }
    email { generate(:email) }
  end
end

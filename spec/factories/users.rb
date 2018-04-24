FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "tester#{i}@gmail.com" }
    password 'password12'
    role 'user'

    trait :admin do
      role 'admin'
    end

    trait :translator do
      role 'translator'
    end

    trait :confirmed do
      confirmed_at DateTime.now
    end
  end
end

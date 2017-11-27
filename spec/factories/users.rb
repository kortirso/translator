FactoryBot.define do
    factory :user do
        sequence(:email) { |i| "tester#{i}@gmail.com" }
        # sequence(:username) { |i| "tester_#{i}" }
        password 'password'
        role 'user'

        trait :admin do
            role 'admin'
        end

        trait :translator do
            role 'translator'
        end
    end
end

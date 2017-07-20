FactoryGirl.define do
    factory :identity do
        uid 123
        provider 'facebook'
        association :user
    end
end

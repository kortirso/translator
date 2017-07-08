FactoryGirl.define do
    factory :identity do
        uid 1234567890
        provider 'facebook'
        association :user
    end
end

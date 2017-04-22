FactoryGirl.define do
    factory :position do
        association :task
        association :translation
    end
end

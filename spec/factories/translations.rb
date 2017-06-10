FactoryGirl.define do
    factory :translation do
        association :base, factory: %i[word ru]
        association :result, factory: %i[word en]
    end
end

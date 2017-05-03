FactoryGirl.define do
    factory :translation do
        association :base, factory: [:word, :ru]
        association :result, factory: [:word, :en]
    end
end

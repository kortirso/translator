FactoryGirl.define do
    factory :translation do
        direction 'ru-en'
        verified false
        association :base, factory: %i[word ru]
        association :result, factory: %i[word en]
    end
end

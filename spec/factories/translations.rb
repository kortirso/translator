FactoryGirl.define do
    factory :translation do
        association :base, factory: :word
        association :result, factory: :word_ru
    end
end

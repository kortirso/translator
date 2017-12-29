FactoryBot.define do
    factory :word do
        trait :en do
            text 'Some text'
            association :locale, :en
        end

        trait :ru do
            text 'Какой-то текст'
            association :locale, :ru
        end
    end
end

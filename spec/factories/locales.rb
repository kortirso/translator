FactoryGirl.define do
    factory :locale do
        trait :en do
            code 'en'
            country_code 'EN'
            names({en: 'English', ru: 'Английский'})
        end

        trait :ru do
            code 'ru'
            country_code 'RU'
            names({en: 'Russian', ru: 'Русский'})
        end
    end
end

FactoryBot.define do
    factory :locale do
        trait :en do
            code 'en'
            country_code 'GB'
            names(en: 'English', ru: 'Английский', da: 'Engelsk')
        end

        trait :ru do
            code 'ru'
            country_code 'RU'
            names(en: 'Russian', ru: 'Русский', da: 'Russisk')
        end

        trait :da do
            code 'da'
            country_code 'DK'
            names(en: 'Danish', ru: 'Датский', da: 'Dansk')
        end
    end
end

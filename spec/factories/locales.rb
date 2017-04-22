FactoryGirl.define do
    factory :locale do
        trait :en do
            code 'en'
            country_code 'en'
        end

        trait :ru do
            code 'ru'
            country_code 'ru'
        end
    end
end

FactoryBot.define do
  factory :word do
    trait :en do
      text 'Hello'
      association :locale, :en
    end

    trait :ru do
      text 'Привет'
      association :locale, :ru
    end

    trait :es do
      text 'Hola'
      association :locale, :es
    end
  end
end

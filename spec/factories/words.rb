FactoryGirl.define do
    factory :word do
        text 'Some text'
        association :locale, :en
    end

    factory :word_ru, class: 'Word' do
        text 'Какой-то текст'
        association :locale, :ru
    end
end

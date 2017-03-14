FactoryGirl.define do
    factory :word do
        text 'Some text'
        locale 'en'
    end

    factory :word_ru, class: 'Word' do
        text 'Какой-то текст'
        locale 'ru'
    end
end

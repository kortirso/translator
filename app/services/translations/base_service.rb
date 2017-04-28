module Translations
    class BaseService
        attr_reader :task, :db_data, :new_words

        def initialize(task)
            @task = task
            @db_data = Translations::Sources::Fromdb.new({task: task})
            @new_words = []
        end

        def translate(word)
            result = db_data.find_translate(word)
            return result if result

            result = Translations::Sources::Yandex.find_translate({task: task, word: word})
            if result
                new_words.push {word: word, result: result}
                return result
            end

            "!#{word}"
        end

        def save_new_words
            locale_from = Locale.find_by(code: task.from)
            locale_to = Locale.find_by(code: task.to)

            new_words.each do |new_word|
                word_1 = Word.find_or_create_by text: new_word[:word].text, locale: locale_from
                word_2 = Word.create text: new_word[:result].text, locale: locale_to
                translation = Translation.create base: word_1, result: word_2
                translation.positions.create task: task
            end
        end
    end
end
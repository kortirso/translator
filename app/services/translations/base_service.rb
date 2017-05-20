module Translations
    class BaseService
        attr_reader :task, :db_data, :new_words

        def initialize(task)
            @task = task
            @db_data = Translations::Sources::Fromdb.new({task: task})
            @new_words = []
        end

        def translate(word)
            answer = db_data.find_translate(word)
            return answer if answer

            answer = Translations::Sources::Yandex.find_translate({task: task, word: word})
            if answer
                new_words.push({word: word, answer: answer})
                return answer
            end

            "!#{word}"
        end

        def save_new_words(translations = [])
            locale_from = Locale.find_by(code: task.from)
            locale_to = Locale.find_by(code: task.to)

            new_words.each do |new_word|
                word_1 = locale_from.words.find_or_create_by text: new_word[:word]
                word_2 = locale_to.words.create text: new_word[:answer]
                translation = Translation.new base: word_1, result: word_2, direction: task.direction(:straight)
                translation.positions.build task: task
                translations << translation
                translation = Translation.new base: word_2, result: word_1, direction: task.direction(:reverse)
                translations << translation
            end

            Translation.import translations, recursive: true
        end
    end
end
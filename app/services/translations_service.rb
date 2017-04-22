class TranslationsService
    attr_reader :task, :db_data

    def initialize(task)
        @task = task
        @db_data = Translations::Fromdb.new({task: task})
    end

    def translate(word)
        answer = db_data.find_translate(word)
        return answer if answer

        answer = Translations::Yandex.find_translate({task: task, word: word})
        return answer if answer

        "!#{word}"
    end
end
class TranslationsService
    attr_reader :task

    def initialize(task)
        @task = task
    end

    def translate(word)
        "!#{word}"
    end
end
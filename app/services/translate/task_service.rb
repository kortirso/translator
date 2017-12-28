module Translate
    # Service for running translations
    class TaskService
        attr_reader :task, :word_service, :translated

        def initialize(args)
            @task = args[:task]
            @word_service = Translate::WordService.new(task: task)
            @translated = []
        end

        def translate(args)
            args[:data].uniq.each { |word| translate_word(word) }
            word_service.save_new_words
        end

        private

        def translate_word(word)
            translated.push(word_service.translate(word))
        end
    end
end

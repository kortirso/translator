module Translate
  # Service for running translations
  class TaskService
    attr_reader :task, :word_service, :translated

    def initialize(args = {})
      @task = args[:task]
      @word_service = Translate::WordService.new(task: task)
    end

    def translate
      task.phrases_for_translation.uniq.each { |word| translate_word(word) }
      word_service.save_new_words
    end

    private def translate_word(word)
      word_service.translate(word: word)
    end
  end
end

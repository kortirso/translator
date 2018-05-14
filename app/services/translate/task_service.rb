module Translate
  # Service for running translations
  class TaskService
    attr_reader :task, :word_service, :translated

    def initialize(args = {})
      @task = args[:task]
      @word_service = Translate::WordService.new(task: task)
    end

    def translate
      task.phrases.each { |phrase| translate_word(phrase.word.text) }
      word_service.save_new_words
      task.positions.each(&:update_phrases_value)
    end

    private def translate_word(word)
      word_service.translate(word: word)
    end
  end
end

module Translate
  # Base translation class
  class WordService
    attr_reader :task, :db_translator, :yandex_translator, :new_words

    def initialize(args = {})
      @task = args[:task]
      @db_translator = Translate::Source::FromDb.new(task: task)
      @yandex_translator = Translate::Source::FromYandex.new(task: task)
      @new_words = []
    end

    def translate(args = {})
      answer = db_translator.find_translation(word: args[:word])
      return answer if answer.present?

      answer = yandex_translator.find_translation(word: args[:word])
      if answer.present?
        new_words << { word: args[:word], answer: answer }
        return answer
      end

      # TODO: save words with unknown translation
      # "!#{args[:word]}"
    end

    def save_new_words
      locale_from = Locale.find_by(code: task.from)
      locale_to = Locale.find_by(code: task.to)

      new_words.each do |new_word|
        word1 = Word.create_or_find_by(text: new_word[:word], locale: locale_from)
        word2 = Word.create(text: new_word[:answer], locale: locale_to)
        Translation.create(base: word1, result: word2)
      end
    end
  end
end

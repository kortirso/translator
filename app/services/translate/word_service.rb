module Translate
  # Base translation class
  class WordService
    attr_reader :task, :db_data, :new_words

    def initialize(args = {})
      @task = args[:task]
      @db_data = Translate::Source::FromDb.new(task: task)
      @new_words = []
    end

    def translate(word)
      answer = db_data.find_translate(word)
      return answer if answer

      answer = Translate::Source::FromYandex.find_translate(task: task, word: word)
      if answer
        new_words.push(word: word, answer: answer)
        return answer
      end

      "!#{word}"
    end

    def save_new_words(translations = [])
      locale_from = Locale.find_by(code: task.from)
      locale_to = Locale.find_by(code: task.to)

      new_words.each do |new_word|
        word1 = locale_from.words.find_or_create_by text: new_word[:word]
        word2 = locale_to.words.create text: new_word[:answer]
        translation = Translation.new base: word1, result: word2, direction: task.direction(:straight)
        translation.positions.build task: task
        translations << translation
        translation = Translation.new base: word2, result: word1, direction: task.direction(:reverse)
        translations << translation
      end

      Translation.import translations, recursive: true
    end
  end
end

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
      answer = db_translator.find_translate(word: args[:word])
      return answer if answer

      answer = yandex_translator.find_translate(word: args[:word])
      if answer
        new_words.push(word: args[:word], answer: answer)
        return answer
      end

      "!#{args[:word]}"
    end

    def save_new_words(translations = [])
      locale_from = Locale.find_by(code: task.from)
      locale_to = Locale.find_by(code: task.to)

      new_words.each do |new_word|
        word1 = locale_from.words.find_or_create_by(text: new_word[:word])
        word2 = locale_to.words.create(text: new_word[:answer])
        translation = Translation.new(base: word1, result: word2, direction: task.direction(:straight))
        translation.positions.build(task: task)
        translations << translation
        translation = Translation.new(base: word2, result: word1, direction: task.direction(:reverse))
        translations << translation
      end

      Translation.import translations, recursive: true
    end
  end
end

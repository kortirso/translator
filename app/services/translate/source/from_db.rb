module Translate
  module Source
    # Get translation from DB
    class FromDb
      attr_reader :task, :locale_from, :locale_to

      def initialize(args = {})
        @task = args[:task]
        @locale_from = Locale.find_by(code: task.from)
        @locale_to = Locale.find_by(code: task.to)
      end

      def find_translation(args = {})
        word_for_translate = Word.find_by(text: args[:word], locale: locale_from)
        return nil if word_for_translate.nil?

        word_translations = word_for_translate.select_translations(locale: locale_to)
        return nil if word_translations.empty?

        # result_word = word_translations.keys.first

        # translation = Translation.find_by(base: word_for_translate, result: result_word)
        # Position.create(task: task)
        word_translations.keys.first
      end
    end
  end
end

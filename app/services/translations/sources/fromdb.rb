module Translations
    module Sources
        class Fromdb
            attr_reader :task, :locale_from, :locale_to

            def initialize(params)
                @task = params[:task]
                @locale_from = Locale.find_by(code: task.from)
                @locale_to = Locale.find_by(code: task.to)
            end

            def find_translate(base_word)
                word_for_translate = locale_from.words.find_by text: base_word
                return false if word_for_translate.nil?

                word_translations = word_for_translate.select_translations(locale_to)
                return false if word_translations.empty?
                
                result_word = word_translations.first
                translation = Translation.find_by base: word_for_translate, result: result_word, direction: task.direction(:straight)
                Position.create translation: translation, task: task
                result_word.text
            end
    end
end

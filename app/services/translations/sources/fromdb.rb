module Translations
    module Sources
        class Fromdb
            attr_reader :task, :locale

            def initialize(params)
                @task = params[:task]
                @locale = Locale.find_by(code: task.from)
            end

            def find_translate(base_word)
                v2(base_word)
            end

            private

            def v2(base_word)
                word_for_translate = Word.find_by(locale: locale, text: base_word)
                return false if word_for_translate.nil?

                word_translations = word_for_translate.select_translations(task.to)
                return false if word_translations.empty?
                
                result_word = word_translations.first
                translation = Translation.find_by(base: word_for_translate, result: result_word) || Translation.find_by(base: result_word, result: word_for_translate)
                Position.create translation: translation, task: task
                result_word.text
            end
        end
    end
end

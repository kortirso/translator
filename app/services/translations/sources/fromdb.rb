module Translations
    module Sources
        # Get translation from DB
        class Fromdb
            attr_reader :task, :locale_from, :locale_to

            def initialize(params)
                @task = params[:task]
                @locale_from = Locale.find_by code: task.from
                @locale_to = Locale.find_by code: task.to
            end

            def find_translate(base_word)
                word_for_translate = locale_from.words.find_by text: base_word
                return false if word_for_translate.nil?

                verified = word_for_translate.translations.verifieded
                if verified.empty?
                    word_translations = word_for_translate.select_translations(locale_to)
                    return false if word_translations.empty?
                else
                    verified_words = verified.collect(&:result).select { |v| v.locale == locale_to }.group_by(&:text)
                    return false if verified_words.empty?
                    word_translations = verified_words.each { |key, value| verified_words[key] = value.count }.sort_by { |_key, value| value }.reverse.to_h
                end

                result_word = locale_to.words.find_by text: word_translations.keys.first

                translation = Translation.find_by base: word_for_translate, result: result_word, direction: task.direction(:straight)
                Position.create translation: translation, task: task
                result_word.text
            end
        end
    end
end

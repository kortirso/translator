module Translations
    module Sources
        class Fromdb
            attr_reader :task, :words

            def initialize(params)
                @task = params[:task]
                #@words = ActiveModel::Serializer::CollectionSerializer.new(Locale.find_by(code: task.from).words, each_serializer: WordSerializer).as_json
            end

            def find_translate(base_word)
                v2(base_word)
            end

            private

            def v1(base_word)
                word = words.select { |w| w[:text] == base_word }
                return false if word.empty?

                word_for_translate = Word.find(word[0][:id])
                word_translations = word_for_translate.select_translations(task.to)
                return false if word_translations.empty?

                result_word = word_translations.first
                translation = Translation.find_by(base: word_for_translate, result: result_word) || Translation.find_by(base: result_word, result: word_for_translate)
                Position.create translation: translation, task: task
                result_word.text
            end

            def v2(base_word)
                word_for_translate = Word.find_by(locale: tr_from, text: base_word)
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

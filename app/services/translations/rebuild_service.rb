module Translations
    class RebuildService
        def self.call(params)
            params[:translations].each do |key, value|
                translation = Translation.find_by(id: key)
                next if translation.nil?
                Translations::RebuildService.update_word(translation, value['result'], params[:task])
            end
        end

        def self.update_word(translation, new_value, task)
            word = translation.result
            if word.text != new_value
                new_word = Word.create text: new_value, locale_id: word.locale_id
                new_translation = Translation.create base: translation.base, result: new_word
                Position.find_by(task: task, translation: translation).update(translation: new_translation)
            end
        end
    end
end
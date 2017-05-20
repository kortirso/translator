module Translations
    class RebuildService
        def self.call(params)
            translations = params[:task].translations
            params[:translations].each do |key, value|
                translation = translations.find_by(id: key)
                next if translation.nil?
                Translations::RebuildService.update_word(translation, value['result'], params[:task])
            end
            Translations::RebuildService.update_task_file(params[:task], translations)
        end

        def self.update_word(translation, new_value, task)
            word = translation.result
            if word.text != new_value
                new_word = word.locale.words.create text: new_value
                new_translation_1 = Translation.create base: translation.base, result: new_word, direction: task.direction(:straight)
                new_translation_2 = Translation.create base: new_word, result: translation.base, direction: task.direction(:reverse)
                Position.find_by(task: task, translation: translation).update(translation: new_translation_1)
            end
        end

        def self.update_task_file(task, translations)
            temporary_text = File.read(task.temporary_file.file.file)
            translations.each { |translation| temporary_text.gsub!("_###{translation.base.text}##_", translation.result.text) }

            File.open(task.result_file_name, 'w') do |f|
                f.write(temporary_text)
                task.result_file = f
            end
            task.status = 'done'
            task.save
        end
    end
end
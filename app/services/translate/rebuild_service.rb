module Translate
    # Service for rebuilding translations by user request
    class RebuildService
        attr_reader :translations

        def initialize(params)
            @task = params[:task]
            @translations = params[:translations]
        end

        def call
            task_translations = task.translations
            translations.each do |key, value|
                translation = task_translations.find_by(id: key)
                next if translation.nil?
                update_word(translation, value['result'])
            end
            update_task_file(task_translations)
        end

        # private section
        private def update_word(translation, new_value)
            word = translation.result
            if word.text != new_value
                new_word = word.locale.words.create text: new_value
                new_translation = Translation.create base: translation.base, result: new_word, direction: task.direction(:straight)
                Translation.create base: new_word, result: translation.base, direction: task.direction(:reverse)
                Position.find_by(task: task, translation: translation).update(translation: new_translation)
            end
        end

        private def update_task_file(translations)
            temporary_text = File.read(task.temporary_file.file.file)
            translations.each { |translation| temporary_text.gsub!("_###{translation.base.text}##_", translation.result.text) }
            save_result_file(task.result_file_name, temporary_text)
        end

        private def save_result_file(file_name, temporary_text)
            File.open(file_name, 'w') do |f|
                f.write(temporary_text)
                task.result_file = f
            end
            task.status = 'done'
            task.save
        end
    end
end

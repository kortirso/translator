module Translations
    class TaskTranslationService
        attr_reader :task, :translation_service, :words_for_translate

        def initialize(args)
            @task = args[:task]
            @translation_service = Translations::BaseService.new(task)
        end

        def translate(args)
            @words_for_translate = args[:words_for_translate].uniq
            translate_file
            translation_service.save_new_words
            task.complete
        end

        private

        def translate_file
            temporary_text = File.read(task.temporary_file.file.file)
            words_for_translate.each { |word| temporary_text.gsub!("_###{word}##_", translation_service.translate(word)) }
            File.open(change_file_name, 'w') do |f|
                f.write(temporary_text)
                task.result_file = f
            end
            task.save
            File.delete(change_file_name)
        end

        def change_file_name
            "#{Rails.root}/public/uploads/tmp/#{task.temporary_file.file.file.split('/')[-1]}"
        end
    end
end
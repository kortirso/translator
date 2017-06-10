module Translations
    # Service for running translations
    class TaskTranslationService
        include Translations::Base

        attr_reader :task, :translation_service, :words_for_translate

        def initialize(args)
            @task = args[:task]
            @translation_service = Translations::BaseService.new(task)
        end

        def translate(args)
            @words_for_translate = args[:words_for_translate].uniq
            translate_file
            translation_service.save_new_words
        end

        private

        def translate_file
            temporary_text = File.read(task.temporary_file.file.file)
            words_for_translate.each { |word| temporary_text.gsub!("_###{word}##_", translation_service.translate(word)) }
            save_result_file(change_file_name, temporary_text)
            File.delete(change_file_name)
        end

        def change_file_name
            "#{Rails.root}/public/uploads/tmp/#{task.temporary_file.file.file.split('/')[-1]}"
        end
    end
end

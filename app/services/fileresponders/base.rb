module Fileresponders
    # common module for all fileresponders
    module Base
        class AuthFailure < StandardError; end

        GUEST_LIMIT = 100
        USER_LIMIT = 200

        attr_reader :task, :words_for_translate, :base_data, :fileloader, :result, :sentence_service

        def initialize(task)
            @task = task
            @words_for_translate = []
            @fileloader = select_fileloader.new(task)
            @sentence_service = Checks::SentenceService.new(self.class.name.demodulize.to_sym)
        end

        def processing
            file_load = fileloader.load
            return false unless file_load
            @base_data = file_load
        rescue
            task.failure(401)
        end

        def translating
            strings_for_translate
            fileloader.save(result)
            Translations::TaskTranslationService.new(task: task).translate(words_for_translate: words_for_translate.flatten)
        rescue AuthFailure => ex
            task.failure(ex.message.to_i)
        end

        private

        def select_fileloader
            "Fileloaders::#{self.class.name.demodulize.capitalize}".constantize
        end
    end
end

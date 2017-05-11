module Fileresponders
    module Base
        GUEST_LIMIT = 50
        USER_LIMIT = 100

        attr_reader :task, :words_for_translate, :base_data, :fileloader, :result

        def initialize(task)
            @task = task
            @words_for_translate = []
        end

        def processing
            file_load = fileloader.load
            return false unless file_load
            @base_data = file_load
        end

        def translating
            strings_for_translate
            fileloader.save(result)
            Translations::TaskTranslationService.new({task: task}).translate({words_for_translate: words_for_translate})
        end
    end
end
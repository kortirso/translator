module FileHandle
    # Base class for converting files
    class ConvertService
        attr_reader :task, :words_for_translate, :sentence_service

        def initialize(args = {})
            @task = args[:task]
            @words_for_translate = []
            @sentence_service = Checks::SentenceService.new(task.framework.extension)
            post_initialize(args)
        end

        # subclasses may override
        private def post_initialize(_args)
            nil
        end
    end
end

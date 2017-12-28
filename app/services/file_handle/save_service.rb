module FileHandle
    # Base class for saving files
    class SaveService
        attr_reader :task

        def initialize(args = {})
            @task = args[:task]
            post_initialize(args)
        end

        # subclasses may override
        private def post_initialize(_args)
            nil
        end
    end
end

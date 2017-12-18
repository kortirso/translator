module FileHandle
    # Base class for saving files
    class SaveService
        def initialize(args = {})
            post_initialize(args)
        end

        # subclasses may override
        private def post_initialize(_args)
            nil
        end
    end
end

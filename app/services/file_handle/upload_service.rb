module FileHandle
    # Base class for uploading files
    class UploadService
        class AuthFailure < StandardError; end

        attr_reader :task, :uploaded_file

        def initialize(args = {})
            @task = args[:task]
            post_initialize(args)
        rescue AuthFailure => ex
            task.failure(ex.message.to_i)
        rescue
            task.failure(103)
        end

        # subclasses may override
        def post_initialize(_args)
            nil
        end
    end
end

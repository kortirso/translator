module FileHandle
  # Base class for uploading files
  class UploadService
    attr_reader :task, :uploaded_file

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

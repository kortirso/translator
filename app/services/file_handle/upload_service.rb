module FileHandle
  # Base class for uploading files
  class UploadService
    attr_reader :task, :uploaded_file

    def initialize(args = {})
      @task = args[:task]
      post_initialize(args)
    end

    def load
      check_file
      check_locale
      returned_value
    end

    # subclasses may override
    private def post_initialize(_args)
      nil
    end

    private def check_file; end

    private def check_locale; end

    private def returned_value; end
  end
end

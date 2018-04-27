module FileHandle
  # Base class for uploading files
  class UploadService
    attr_reader :task, :uploaded_file, :locale

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
    private def post_initialize(_args); end

    private def check_file; end

    private def prepare_file
      task_base_file_exist?
    end

    private def task_base_file_exist?
      raise StandardError, '101' unless task.file.attached?
    end

    private def check_locale
      locale_is_correct?
      task_update
    end

    private def locale_is_correct?
      return true if locale.size == 2
      raise StandardError, '202'
    end

    private def task_update
      task.update(from: locale, status: 'active')
    end

    private def file_name
      task.file_name
    end

    private def returned_value
      uploaded_file
    end
  end
end

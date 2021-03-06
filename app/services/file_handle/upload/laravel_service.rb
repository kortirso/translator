require 'json'

module FileHandle
  module Upload
    # FileUploader for *.json from Laravel
    class LaravelService < FileHandle::UploadService
      private def post_initialize(_args)
        prepare_file
        @uploaded_file = JSON.parse(task.file_content)
      end

      private def check_file
        raise StandardError, '110' unless uploaded_file.is_a?(Hash)
      end

      private def locale
        @locale ||= file_name.split('.')[0]
      end
    end
  end
end

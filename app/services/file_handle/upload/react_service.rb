require 'json'

module FileHandle
  module Upload
    # FileUploader for *.json from ReactJS
    class ReactService < FileHandle::UploadService
      # private section
      private def post_initialize(_args)
        prepare_file
        @uploaded_file = JSON.parse(task.file_content)
      end

      private def check_file
        raise StandardError, '110' unless uploaded_file.is_a?(Hash)
        raise StandardError, '110' unless uploaded_file.keys.count == 1
      end

      private def locale
        @locale ||= uploaded_file.keys.first
      end

      private def returned_value
        uploaded_file.values.first
      end
    end
  end
end

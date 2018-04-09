module FileHandle
  module Upload
    # FileUploader for *.php from Yii
    class YiiService < FileHandle::UploadService
      # private section
      private def post_initialize(_args)
        prepare_file
        @uploaded_file = task.file_content
      end

      private def locale
        @locale ||= file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1]
      end
    end
  end
end

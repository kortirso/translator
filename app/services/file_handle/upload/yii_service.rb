module FileHandle
  module Upload
    # FileUploader for *.php from Yii
    class YiiService < FileHandle::UploadService
      include FileHandle::Upload::Concerns::Stringable

      private def locale
        @locale ||= file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1]
      end
    end
  end
end

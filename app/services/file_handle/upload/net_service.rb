require 'nokogiri'

module FileHandle
  module Upload
    # FileUploader for *.resx from .NET
    class NetService < FileHandle::UploadService
      # private section
      private def post_initialize(_args)
        prepare_file
        @uploaded_file = Nokogiri::XML(File.open(task.file_name))
      end

      private def check_file
        raise StandardError, '110' unless uploaded_file.is_a?(Nokogiri::XML::Document)
      end

      private def locale
        @locale ||= file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1].split('-')[0]
      end
    end
  end
end

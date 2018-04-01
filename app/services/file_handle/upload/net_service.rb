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

      private def prepare_file
        task_base_file_exist?
      end

      private def task_base_file_exist?
        raise StandardError, '101' unless File.file?(task.file_name)
      end

      private def check_locale
        locale = file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1].split('-')[0]
        locale_is_correct?(locale)
        task_update(locale)
      end

      private def file_name
        task.file_name.split('/')[-1]
      end

      private def locale_is_correct?(locale)
        return true if locale.size == 2
        raise StandardError, '202'
      end

      private def task_update(locale)
        task.update(from: locale, status: 'active')
      end

      private def returned_value
        uploaded_file
      end
    end
  end
end

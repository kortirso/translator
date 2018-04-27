require 'yaml'
require 'fileutils'

module FileHandle
  module Upload
    # FileUploader for *.yml
    class RailsService < FileHandle::UploadService
      private def post_initialize(_args)
        prepare_file
        @uploaded_file = YAML.safe_load(task.file_content)
      end

      private def prepare_file
        super
        # remove_comments
      end

      private def remove_comments(file_name = task.file_name)
        open(file_name, 'r') do |f|
          open("#{file_name}.tmp", 'w') do |f2|
            f.each_line do |line|
              f2.write(line) unless line.start_with?('#')
            end
          end
        end
        FileUtils.mv "#{file_name}.tmp", file_name
      end

      private def check_file
        raise StandardError, '110' unless uploaded_file.is_a?(Hash)
        raise StandardError, '110' unless uploaded_file.keys.count == 1
      end

      private def locale
        @locale ||= uploaded_file_locale.size == 2 ? uploaded_file_locale : uploaded_file_locale.split('-')[0]
      end

      private def uploaded_file_locale
        uploaded_file.keys.first
      end

      private def returned_value
        uploaded_file.values.first
      end
    end
  end
end

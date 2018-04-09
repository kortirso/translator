require 'json'

module FileHandle
  module Save
    # Saving service for React
    class ReactService < FileHandle::SaveService
      def save_temporary(args = {})
        task.save_file(temporary_file_name, temporary_hash(args).to_json, 'temporary')
      end

      private def temporary_hash(args)
        temp_hash = JSON.parse(task.file_content)
        temp_hash[task.to] = args[:data]
        temp_hash
      end

      private def define_filename(type)
        file_name = task.file_name
        "#{TEMP_FOLDER}#{task.id}.#{type}.#{file_name}"
      end
    end
  end
end

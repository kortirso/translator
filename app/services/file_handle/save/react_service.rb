require 'json'

module FileHandle
  module Save
    # Saving service for React
    class ReactService < FileHandle::SaveService
      def save_temporary(args = {})
        temp_hash = JSON.parse(task.file_content)
        temp_hash[task.to] = args[:data]
        task.save_file(temporary_file_name, temp_hash.to_json, 'temporary')
      end

      private def define_filename(type)
        file_name = task.file_name
        "#{TEMP_FOLDER}#{task.id}.#{type}.#{file_name}"
      end
    end
  end
end

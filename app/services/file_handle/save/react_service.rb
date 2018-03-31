require 'json'

module FileHandle
  module Save
    # Saving service for React
    class ReactService < FileHandle::SaveService
      def save_temporary(temporary, temp_file_name = temporary_file_name)
        temp_hash = JSON.parse(File.read(task.file_name))
        temp_hash[task.to] = temporary
        File.write(temp_file_name, temp_hash.to_json)
        task.save_temporary_file(temp_file_name)
      end

      # private section
      private def temporary_file_name
        file_name = task.file_name.split('/')[-1]
        "#{Rails.root}/public/uploads/tmp/#{file_name}"
      end
    end
  end
end

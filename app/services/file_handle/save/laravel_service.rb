require 'json'

module FileHandle
  module Save
    # Saving service for Laravel
    class LaravelService < FileHandle::SaveService
      private def define_filename(type)
        file_name = task.to
        "#{TEMP_FOLDER}#{task.id}.#{type}.#{file_name}.json"
      end
    end
  end
end

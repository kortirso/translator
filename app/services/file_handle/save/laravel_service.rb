require 'json'

module FileHandle
  module Save
    # Saving service for Laravel
    class LaravelService < FileHandle::SaveService
      private def define_temp_filename
        file_name = "#{task.to}.json"
        "#{Rails.root}/public/uploads/tmp/#{file_name}"
      end
    end
  end
end

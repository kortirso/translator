module FileHandle
  module Save
    # Saving service for IOs
    class IosService < FileHandle::SaveService
      private def define_temp_filename
        file_name = task.file_name.split('/')[-1].split('.')[0]
        "#{Rails.root}/public/uploads/tmp/#{file_name}.#{task.to}.strings"
      end
    end
  end
end

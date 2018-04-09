module FileHandle
  module Save
    # Saving service for IOs
    class IosService < FileHandle::SaveService
      private def define_filename(type)
        file_name = task.file_name.split('.')[0]
        "#{TEMP_FOLDER}#{task.id}.#{type}.#{file_name}.#{task.to}.strings"
      end
    end
  end
end

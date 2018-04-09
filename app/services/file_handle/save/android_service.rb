module FileHandle
  module Save
    # Saving service for Android
    class AndroidService < FileHandle::SaveService
      private def define_filename(type)
        file_name = task.file_name.split('/')[-1].split('.')[0]
        "#{TEMP_FOLDER}#{task.id}.#{type}.#{file_name}.#{task.to}.xml"
      end
    end
  end
end

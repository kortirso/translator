module FileHandle
  module Save
    # Saving service for .NET
    class NetService < FileHandle::SaveService
      private def define_filename(type)
        translation_locale = Locale.find_by(code: task.to)
        file_name = task.file_name.split('.')[0]
        "#{TEMP_FOLDER}#{task.id}.#{type}.#{file_name}.#{translation_locale.code}-#{translation_locale.country_code}.resx"
      end
    end
  end
end

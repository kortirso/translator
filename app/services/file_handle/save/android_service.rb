module FileHandle
  module Save
    # Saving service for Android
    class AndroidService < FileHandle::SaveService
      private def define_filename(type)
        super(type) + 'xml'
      end
    end
  end
end

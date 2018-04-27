module FileHandle
  module Save
    # Saving service for IOs
    class IosService < FileHandle::SaveService
      private def define_filename(type)
        super(type) + 'strings'
      end
    end
  end
end

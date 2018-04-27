module FileHandle
  module Save
    # Saving service for Yii
    class YiiService < FileHandle::SaveService
      private def define_filename(type)
        super(type) + 'php'
      end
    end
  end
end

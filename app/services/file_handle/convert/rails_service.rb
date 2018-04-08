module FileHandle
  module Convert
    # FileUploader for *.yml
    class RailsService < FileHandle::ConvertService
      include FileHandle::Convert::Concerns::Jsonable
    end
  end
end

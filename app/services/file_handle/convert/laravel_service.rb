module FileHandle
  module Convert
    # FileUploader for *.json from Laravel
    class LaravelService < FileHandle::ConvertService
      include FileHandle::Convert::Concerns::Jsonable
    end
  end
end

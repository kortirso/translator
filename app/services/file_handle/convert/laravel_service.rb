module FileHandle
  module Convert
    # FileConverter for *.json from Laravel
    class LaravelService < FileHandle::ConvertService
      include FileHandle::Convert::Concerns::Jsonable
    end
  end
end

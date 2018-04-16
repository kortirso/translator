module FileHandle
  module Convert
    # FileConverter for *.yml
    class RailsService < FileHandle::ConvertService
      include FileHandle::Convert::Concerns::Jsonable
    end
  end
end

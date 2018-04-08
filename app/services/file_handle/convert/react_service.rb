module FileHandle
  module Convert
    # FileUploader for *.json from ReactJS
    class ReactService < FileHandle::ConvertService
      include FileHandle::Convert::Concerns::Jsonable
    end
  end
end

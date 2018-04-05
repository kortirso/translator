module FileHandle
  module Convert
    # FileUploader for *.json from ReactJS
    class ReactService < FileHandle::ConvertService
      def convert(data, new_data = {})
        data.each do |key, value|
          checked = fragment_service.call(value)
          words_for_translate.push checked[:blocks_for_translate]
          new_data[key] = checked[:sentence]
        end
        @temporary = new_data
      end
    end
  end
end

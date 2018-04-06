module FileHandle
  module Convert
    # FileUploader for *.json from Laravel
    class LaravelService < FileHandle::ConvertService
      def convert(data, new_data = {})
        data.each do |key, value|
          checked = fragment_service.perform_sentence(value)
          words_for_translate << checked[:blocks_for_translate]
          new_data[key] = checked[:sentence]
        end
        @temporary = new_data
      end
    end
  end
end

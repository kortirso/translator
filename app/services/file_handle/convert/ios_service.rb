module FileHandle
  module Convert
    # FileConverter for *.strings from IOs
    class IosService < FileHandle::ConvertService
      def convert(data, arr = [])
        data.lines.each do |line|
          if line[0] != "\n" && line[0] != '/'
            word = line.split('"')[-2]
            line.gsub!(word, fragment_service.perform_sentence(word))
          end
          arr << line
        end
        @temporary = arr.join
      end
    end
  end
end

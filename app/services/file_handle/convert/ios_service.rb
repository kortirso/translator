module FileHandle
  module Convert
    # FileUploader for *.strings from IOs
    class IosService < FileHandle::ConvertService
      def convert(data, arr = [])
        data.lines.each do |line|
          if line[0] != "\n" && line[0] != '/'
            word = line.split('"')[-2]
            checked = fragment_service.perform_sentence(word)
            words_for_translate << checked[:blocks_for_translate]
            line.gsub!(word, checked[:sentence])
          end
          arr << line
        end
        @temporary = arr.join
      end
    end
  end
end

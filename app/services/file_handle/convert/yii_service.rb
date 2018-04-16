module FileHandle
  module Convert
    # FileConverter for *.php from Yii
    class YiiService < FileHandle::ConvertService
      def convert(data, arr = [])
        data.lines.each do |line|
          if line.end_with?(",\n")
            word = line.split('=>')[-1].chop.strip.slice(1..-3)
            line.gsub!(word, fragment_service.perform_sentence(word))
          end
          arr << line
        end
        @temporary = arr.join
      end
    end
  end
end

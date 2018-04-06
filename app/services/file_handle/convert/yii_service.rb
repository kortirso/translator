module FileHandle
  module Convert
    # FileUploader for *.php from Yii
    class YiiService < FileHandle::ConvertService
      def convert(data, arr = [])
        data.lines.each do |line|
          if line.end_with?(",\n")
            word = line.split('=>')[-1].chop.strip.slice(1..-3)
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

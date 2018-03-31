module FileHandle
  module Convert
    # FileUploader for *.php from Yii
    class YiiService < FileHandle::ConvertService
      attr_reader :temporary

      def convert(data, arr = [])
        data.lines.each do |line|
          if line.end_with?(",\n")
            word = line.split('=>')[-1].chop.strip.slice(1..-3)
            checked = sentence_service.call(word)
            words_for_translate.push checked[:blocks_for_translate]
            line.gsub!(word, checked[:sentence])
          end
          arr.push line
        end
        @temporary = arr.join
      end
    end
  end
end

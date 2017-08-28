module Fileresponders
    # Fileresponder for *.php
    class Php
        include Fileresponders::Base

        private

        def strings_for_translate(arr = [])
            base_data.lines.each do |line|
                if line.end_with?(",\n")
                    word = line.split("=>")[-1].chop.strip.slice(1..-3)
                    checked = sentence_service.call(word)
                    words_for_translate.push checked[:blocks_for_translate]
                    line.gsub!(word, checked[:sentence])
                end
                arr.push line
            end
            @result = arr.join
        rescue
            raise AuthFailure, '402'
        end
    end
end

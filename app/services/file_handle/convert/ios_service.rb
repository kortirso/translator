module FileHandle
    module Convert
        # FileUploader for *.strings from IOs
        class IosService < FileHandle::ConvertService
            attr_reader :temporary

            def convert(data, arr = [])
                data.lines.each do |line|
                    if line[0] != "\n" && line[0] != '/'
                        word = line.split('"')[-2]
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

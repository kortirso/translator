module Fileresponders
    # Fileresponder for *.strings
    class Strings
        include Fileresponders::Base

        LINES_PER_STRING = 3

        def check_permissions
            return task.failure(301) if task.user.nil? && base_data.lines.size / LINES_PER_STRING > GUEST_LIMIT
            return task.failure(302) if task.user.present? && base_data.lines.size / LINES_PER_STRING > USER_LIMIT
            true
        end

        private

        def strings_for_translate(arr = [])
            base_data.lines.each do |line|
                if line[0] != "\n" && line[0] != '/'
                    word = line.split('"')[-2]
                    words_for_translate.push word
                    line.gsub!(word, "_###{word}##_")
                end
                arr.push line
            end
            @result = arr.join
        end
    end
end

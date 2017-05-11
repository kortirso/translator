module Fileresponders
    class Strings
        include Fileresponders::Base

        LINES_PER_STRING = 3

        def initialize(task)
            super(task)
            @fileloader = Fileloaders::Strings.new(task)
            @result = []
        end

        def check_permissions
            return task.failure(301) if task.user.nil? && base_data.lines.size / LINES_PER_STRING > GUEST_LIMIT
            return task.failure(302) if task.user.present? && base_data.lines.size / LINES_PER_STRING > USER_LIMIT
            true
        end

        private

        def strings_for_translate
            base_data.lines.each_with_index do |value, index|
                if value[0] != "\n" && value[0] != '/'
                    word = value.split('"')[-2]
                    words_for_translate.push word
                    value.gsub!(word, "_###{word}##_")
                end
                result.push value
            end
        end
    end
end

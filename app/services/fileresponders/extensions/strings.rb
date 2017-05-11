module Fileresponders
    module Extensions
        class Strings
            GUEST_LIMIT = 50
            USER_LIMIT = 100
            LINES_PER_STRING = 3

            attr_reader :task, :strings_file, :result_strings, :words_for_translate

            def initialize(task)
                @task = task
                @result_strings = []
                @words_for_translate = []
            end

            def processing
                return task.failure(101) unless File.file? task.file_name

                @strings_file = File.read task.file_name
                task.update(from: 'en')
                true
            end

            def check_permissions
                return task.failure(301) if task.user.nil? && strings_file.lines.size / LINES_PER_STRING > GUEST_LIMIT
                return task.failure(302) if task.user.present? && strings_file.lines.size / LINES_PER_STRING > USER_LIMIT
                true
            end

            def translating
                strings_for_translate
                save_to_temporary_file
                Translations::TaskTranslationService.new({task: task}).translate({words_for_translate: words_for_translate})
            end

            private

            def strings_for_translate
                strings_file.lines.each_with_index do |value, index|
                    if value[0] != "\n" && value[0] != '/'
                        word = value.split('"')[-2]
                        words_for_translate.push word
                        value.gsub!(word, "_###{word}##_")
                    end
                    result_strings.push value
                end
            end

            def save_to_temporary_file
                temp_file_name = change_file_name
                File.write(temp_file_name, result_strings.join)
                File.open(temp_file_name) { |f| task.temporary_file = f }
                task.save
                File.delete(temp_file_name)
            end

            def change_file_name
                "#{Rails.root}/public/uploads/tmp/#{task.file_name.split('/')[-1]}"
            end
        end
    end
end

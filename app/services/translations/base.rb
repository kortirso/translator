module Translations
    module Base

        attr_reader :task

        private

        def save_result_file(filename, temporary_text)
            File.open(filename, 'w') do |f|
                f.write(temporary_text)
                task.result_file = f
            end
            task.status = 'done'
            task.save
        end
    end
end
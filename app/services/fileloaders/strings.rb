module Fileloaders
    class Strings
        include Fileloaders::Base

        def load
            return false unless task_base_file_exist?
            task.update(from: 'en')
            File.read task.file_name
        end

        def save(result_strings)
            temp_file_name = change_file_name
            File.write(temp_file_name, result_strings.join)
            File.open(temp_file_name) { |f| task.temporary_file = f }
            task.save
            File.delete(temp_file_name)
        end

        private

        def change_file_name
            "#{Rails.root}/public/uploads/tmp/#{task.file_name.split('/')[-1]}"
        end
    end
end
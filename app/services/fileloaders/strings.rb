module Fileloaders
    # Fileloader for *.strings
    class Strings
        include Fileloaders::Base

        def load
            return false unless task_base_file_exist?
            task.update(from: 'en')
            File.read task.file_name
        end

        def save(result, temp_file_name = change_file_name)
            File.write(temp_file_name, result)
            task.save_temporary_file(temp_file_name)
        end

        private

        def change_file_name
            "#{Rails.root}/public/uploads/tmp/#{task.file_name.split('/')[-1]}"
        end
    end
end

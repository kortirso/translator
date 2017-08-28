module Fileloaders
    # Fileloader for *.php
    class Php
        include Fileloaders::Base

        def load
            return false unless task_base_file_exist?
            file_name = task.file_name.split('/')[-1]
            locale = file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1].split('.')[1]
            return task.failure(202) if locale.size != 2
            task.update(from: locale)
            File.read task.file_name
        end

        def save(result, temp_file_name = change_file_name)
            File.write(temp_file_name, result)
            task.save_temporary_file(temp_file_name)
        end

        private

        def change_file_name
            file_name = task.file_name.split('/')[-1].split('.')[0]
            "#{Rails.root}/public/uploads/tmp/#{file_name}.#{task.to}.php"
        end
    end
end

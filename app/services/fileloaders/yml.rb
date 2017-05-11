require 'yaml'

module Fileloaders
    class Yml
        include Fileloaders::Base

        def load
            return false unless task_base_file_exist?
            yaml_file = YAML.load_file task.file_name
            return task.failure(110) if !yaml_file.is_a?(Hash) || yaml_file.keys.count != 1 || yaml_file.values.count != 1
            task.update(from: yaml_file.keys.first)
            yaml_file.values.first
        end

        def save(hash_for_save = {})
            hash_for_save[task.to] = finish_hash
            temp_file_name = change_file_name
            File.write(temp_file_name, hash_for_save.to_yaml)
            File.open(temp_file_name) { |f| task.temporary_file = f }
            task.save
            File.delete(temp_file_name)
        end

        private

        def change_file_name
            file_name_array = task.file_name.split('/')
            file_name_array[-1] = "#{task.to}.#{file_name_array[-1].split('.')[1]}"
            file_name_array.join('/')
        end
    end
end
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

        def save(result, temp_file_name = change_file_name)
            File.write(temp_file_name, { task.to => result }.to_yaml)
            task.save_temporary_file(temp_file_name)
        end

        private

        def change_file_name
            "#{Rails.root}/public/uploads/tmp/#{task.to}.yml"
        end
    end
end
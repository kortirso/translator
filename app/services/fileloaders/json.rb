require 'json'

module Fileloaders
    # Fileloader for *.json
    class Json
        include Fileloaders::Base

        attr_reader :json_file

        def load
            return false unless task_base_file_exist?
            @json_file = JSON.parse(File.read(task.file_name))
            return task.failure(110) if !json_file.is_a?(Hash) || json_file.keys.count != 1
            task.update(from: json_file.keys.first)
            json_file.values.first
        end

        def save(result, temp_file_name = change_file_name)
            json_file[task.to] = result
            File.write(temp_file_name, json_file.to_json)
            task.save_temporary_file(temp_file_name)
        end

        private

        def change_file_name
            "#{Rails.root}/public/uploads/tmp/#{task.file_name.split('/')[-1]}"
        end
    end
end

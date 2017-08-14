require 'json'

module Fileloaders
    # Fileloader for *.json
    class Json
        include Fileloaders::Base

        attr_reader :json_file, :locale

        def initialize(task)
            super(task)
            @locale = nil
        end

        def load
            return false unless task_base_file_exist?
            @json_file = JSON.parse(File.read(task.file_name))
            return task.failure(110) unless json_file.is_a?(Hash)

            if json_file.keys.count != 1
                @locale = task.file_name.split('/')[-1].split('.')[0]
            end

            loc = locale.nil? ? json_file.keys.first : locale
            return task.failure(202) if loc.size != 2
            task.update(from: loc)
            locale.nil? ? json_file.values.first : json_file
        end

        def save(result, temp_file_name = change_file_name)
            if locale.nil?
                @json_file[task.to] = result
                json_file.delete(task.from)
            else
                @json_file = result
            end
            File.write(temp_file_name, json_file.to_json)
            task.save_temporary_file(temp_file_name)
        end

        private

        def change_file_name
            file_name = locale.nil? ? task.file_name.split('/')[-1].gsub('.json', ".#{task.to}.json") : "#{task.to}.json"
            "#{Rails.root}/public/uploads/tmp/#{file_name}"
        end
    end
end

require 'json'

module FileHandle
    module Save
        # Saving service for Laravel
        class LaravelService < FileHandle::SaveService
            def save_temporary(temporary, temp_file_name = temporary_file_name)
                File.write(temp_file_name, temporary.to_json)
                task.save_temporary_file(temp_file_name)
            end

            # private section
            private def temporary_file_name
                file_name = "#{task.to}.json"
                "#{Rails.root}/public/uploads/tmp/#{file_name}"
            end
        end
    end
end

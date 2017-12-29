require 'yaml'

module FileHandle
    module Save
        # Saving service for Ruby on Rails framework
        class RailsService < FileHandle::SaveService
            def save_temporary(temporary, temp_file_name = temporary_file_name)
                File.write(temp_file_name, { task.to => temporary }.to_yaml(line_width: 500))
                task.save_temporary_file(temp_file_name)
            end

            # private section
            private def temporary_file_name
                file_name = task.file_name.split('/')[-1]
                file_name = file_name.split('.').size <= 2 ? "#{task.to}.yml" : "#{file_name.split('.')[0]}.#{task.to}.yml"
                "#{Rails.root}/public/uploads/tmp/#{file_name}"
            end
        end
    end
end

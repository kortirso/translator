require 'yaml'
require 'fileutils'

module FileHandle
    module Save
        # Saving service for Ruby on Rails framework
        class RailsService < FileHandle::SaveService
            def save_temporary(temporary, temp_file_name = temporary_file_name)
                File.write(temp_file_name, { task.to => temporary }.to_yaml(line_width: 500))
                task.save_temporary_file(temp_file_name)
            end

            def save_result(args = {})
                temporary_text = File.read(task.temporary_file.file.file)
                args[:data].uniq.each_with_index { |word, index| temporary_text.gsub!("_###{word}##_", args[:translated][index]) }
                save_result_file(change_file_name, temporary_text)
                File.delete(change_file_name)
            end

            private

            def temporary_file_name
                file_name = task.file_name.split('/')[-1]
                file_name = file_name.split('.').size <= 2 ? "#{task.to}.yml" : "#{file_name.split('.')[0]}.#{task.to}.yml"
                "#{Rails.root}/public/uploads/tmp/#{file_name}"
            end

            def change_file_name
                "#{Rails.root}/public/uploads/tmp/#{task.temporary_file.file.file.split('/')[-1]}"
            end

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
end

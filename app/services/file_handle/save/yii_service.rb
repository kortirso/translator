module FileHandle
    module Save
        # Saving service for Yii
        class YiiService < FileHandle::SaveService
            def save_temporary(temporary, temp_file_name = temporary_file_name)
                File.write(temp_file_name, temporary)
                task.save_temporary_file(temp_file_name)
            end

            # private section
            private def temporary_file_name
                file_name = task.file_name.split('/')[-1].split('.')[0]
                "#{Rails.root}/public/uploads/tmp/#{file_name}.#{task.to}.php"
            end
        end
    end
end

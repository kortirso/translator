require 'json'

module FileHandle
    module Upload
        # FileUploader for *.json from ReactJS
        class ReactService < FileHandle::UploadService
            def load
                check_file
                check_locale
                returned_value
            end

            # private section
            private def post_initialize(_args)
                prepare_file
                @uploaded_file = JSON.parse(File.read(task.file_name))
            end

            private def prepare_file
                task_base_file_exist?
            end

            private def task_base_file_exist?
                raise StandardError, '101' unless File.file?(task.file_name)
            end

            private def check_file
                raise StandardError, '110' unless uploaded_file.is_a?(Hash)
                raise StandardError, '110' unless uploaded_file.keys.count == 1
            end

            private def check_locale
                locale = uploaded_file.keys.first
                locale_is_correct?(locale)
                task_update(locale)
            end

            private def locale_is_correct?(locale)
                return true if locale.size == 2
                raise StandardError, '202'
            end

            private def task_update(locale)
                task.update(from: locale, status: 'active')
            end

            private def returned_value
                uploaded_file.values.first
            end
        end
    end
end

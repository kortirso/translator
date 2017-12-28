module FileHandle
    module Upload
        # FileUploader for *.strings from IOs
        class IosService < FileHandle::UploadService
            def post_initialize(_args)
                prepare_file
                @uploaded_file = File.read(task.file_name)
            end

            def load
                check_locale
                returned_value
            end

            private def prepare_file
                task_base_file_exist?
            end

            private def task_base_file_exist?
                raise StandardError, '101' unless File.file?(task.file_name)
            end

            private def check_locale
                locale = file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1].split('.')[1]
                locale_is_correct?(locale)
                task_update(locale)
            end

            private def file_name
                task.file_name.split('/')[-1]
            end

            private def locale_is_correct?(locale)
                return true if locale.size == 2
                raise StandardError, '202'
            end

            private def task_update(locale)
                task.update(from: locale, status: 'active')
            end

            private def returned_value
                uploaded_file
            end
        end
    end
end

require 'yaml'
require 'fileutils'

module FileHandle
    module Upload
        # FileUploader for *.yml
        class RailsService < FileHandle::UploadService
            def load
                check_file
                check_locale
                returned_value
            end

            # private section
            private def post_initialize(_args)
                prepare_file
                @uploaded_file = YAML.load_file(task.file_name)
            end

            private def prepare_file
                task_base_file_exist?
                remove_comments
            end

            private def task_base_file_exist?
                raise StandardError, '101' unless File.file?(task.file_name)
            end

            private def remove_comments(file_name = task.file_name)
                open(file_name, 'r') do |f|
                    open("#{file_name}.tmp", 'w') do |f2|
                        f.each_line do |line|
                            f2.write(line) unless line.start_with?('#')
                        end
                    end
                end
                FileUtils.mv "#{file_name}.tmp", file_name
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
                return true if locale.split('-')[0].size == 2
                raise StandardError, '202'
            end

            private def task_update(locale)
                task.update(from: locale.size == 2 ? locale : locale.split('-')[0], status: 'active')
            end

            private def returned_value
                uploaded_file.values.first
            end
        end
    end
end

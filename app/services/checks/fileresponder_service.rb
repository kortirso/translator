module Checks
    # Returns fileresponder's class
    class FileresponderService
        class << self
            def call(task)
                extension = task.file_name.split('.').last
                return "Fileresponders::#{extension.capitalize}".constantize if extension == task.framework.extension
                task.failure(102)
            end

            def call2(task)
                extension = task.file_name.split('.').last
                return task.framework.service if extension == task.framework.extension
                task.failure(102)
            end
        end
    end
end

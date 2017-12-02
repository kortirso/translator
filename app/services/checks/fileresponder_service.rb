module Checks
    # Returns fileresponder's class
    class FileresponderService
        def self.call(task)
            extension = task.file_name.split('.').last
            return "Fileresponders::#{extension.capitalize}".constantize if extension == task.framework.extension
            task.failure(102)
        end
    end
end

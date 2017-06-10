module Fileloaders
    # common module for all fileloaders
    module Base
        attr_reader :task

        def initialize(task)
            @task = task
        end

        private

        def task_base_file_exist?
            return task.failure(101) unless File.file? task.file_name
            true
        end
    end
end

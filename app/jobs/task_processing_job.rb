class TaskProcessingJob < ApplicationJob
    queue_as :default

    def perform(task)
        TaskProcessingService.execute(task)
    end
end

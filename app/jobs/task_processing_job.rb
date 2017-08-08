# Perform task processing
class TaskProcessingJob < ApplicationJob
    queue_as :default

    def perform(task_id)
        TaskProcessingService.delay_for(3.seconds).execute(task_id)
    end
end

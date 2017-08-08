# Perform task processing
class TaskProcessingJob < ApplicationJob
    queue_as :default

    def perform(task)
        TaskProcessingService.delay_for(10.seconds).execute(task)
    end
end

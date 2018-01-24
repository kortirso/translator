# Perform task processing
class TaskProcessingJob < ApplicationJob
  queue_as :default

  def perform(task)
    TaskProcessingService.delay_for(3.seconds).call(task: task)
  end
end

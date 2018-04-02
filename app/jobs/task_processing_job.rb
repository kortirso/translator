# Perform task processing
class TaskProcessingJob < ApplicationJob
  queue_as :default

  def perform(task)
    TaskProcessingService.new(task: task).call
  end
end

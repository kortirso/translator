# Perform rebuild translation
class TaskUpdatingJob < ApplicationJob
  queue_as :default

  def perform(task)
    Translate::RebuildService.new(task: task).call
  end
end

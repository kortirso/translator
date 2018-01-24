# Perform rebuild translation
class TaskUpdatingJob < ApplicationJob
  queue_as :default

  def perform(translations, task)
    Translate::RebuildService.new(translations: translations, task: task).call
  end
end

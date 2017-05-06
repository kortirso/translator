class TaskUpdatingJob < ApplicationJob
    queue_as :default

    def perform(translations, task)
        Translations::RebuildService.call({translations: translations, task: task})
    end
end

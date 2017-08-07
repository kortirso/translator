# Steps of processing for task
class TaskProcessingService
    def self.execute(task)
        fileresponder = SelectFileresponderService.call(task)
        return false unless fileresponder

        file_handler = fileresponder.new(task)
        return false unless file_handler.processing
        return false unless CheckTranslateDirectionService.call(task)
        # return false unless file_handler.check_permissions

        file_handler.translating
    end
end

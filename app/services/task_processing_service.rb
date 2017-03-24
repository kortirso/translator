class TaskProcessingService
    def self.execute(task)
        fileresponder = FileresponderService.get_fileresponder(task)
        return false unless fileresponder

        file_handler = fileresponder.new(task)
        return false unless file_handler.processing

        file_handler.translating
    end
end
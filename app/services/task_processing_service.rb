class TaskProcessingService
    def self.execute(task)
        fileresponder = Fileresponders::ExtensionService.get_fileresponder(task)
        return false unless fileresponder

        file_handler = fileresponder.new(task)
        return false unless file_handler.processing
        return false unless file_handler.check_permissions
        return false unless Translations::LangExistService.call(task)

        file_handler.translating
    end
end
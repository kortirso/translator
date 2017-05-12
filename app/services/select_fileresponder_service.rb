class SelectFileresponderService
    def self.call(task)
        extension = CheckExtensionService.call(task.file_name.split('.').last)
        "Fileresponders::#{extension.capitalize}".constantize rescue task.failure(102)
    end
end
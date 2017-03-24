class FileresponderService
    def self.get_fileresponder(task)
        extension = ExtensionCheckingService.check_extension(task.file_name.split('.').last)
        "Fileresponders::#{extension.capitalize}".constantize rescue false
    end
end
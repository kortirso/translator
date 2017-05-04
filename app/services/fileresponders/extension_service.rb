module Fileresponders
    class ExtensionService
        def self.get_fileresponder(task)
            extension = Fileresponders::CheckingService.check_extension(task.file_name.split('.').last)
            "Fileresponders::Extensions::#{extension.capitalize}".constantize rescue task.failure(102)
        end
    end
end
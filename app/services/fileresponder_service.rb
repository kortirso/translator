class FileresponderService
    def self.get_fileresponder(task)
        extension = task.file_name.split('.').last
        "Fileresponders::#{extension.capitalize}".constantize
    end
end
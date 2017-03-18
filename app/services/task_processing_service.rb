class TaskProcessingService
    def self.execute(task)
        fileresponder = FileresponderService.get_fileresponder(task)
        return false unless check_existence(fileresponder)

        file_handler = fileresponder.new(task)
        return false unless file_handler.processing

        file_handler.translating
    end

    private

    def self.check_existence(class_name)
        Object.const_get(class_name.to_s).is_a? Class rescue false
    end
end
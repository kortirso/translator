# Steps of processing for task
class TaskProcessingService
    class << self
        # old method
        def execute(task)
            fileresponder = Checks::FileresponderService.call(task)
            return false unless fileresponder

            file_handler = fileresponder.new(task)
            return false unless file_handler.processing
            return false unless Checks::TranslateDirectionService.call(task)
            # return false unless file_handler.check_permissions

            file_handler.translating
        end

        # new method
        def call(task)
            file_service = Checks::FileresponderService.call2(task)
            return false if file_service.nil?

            file_uploader = "FileHandle::Upload::#{file_service}".constantize.new(task: task)
            uploaded = file_uploader.load
            return false if uploaded.nil?

            file_converter = "FileHandle::Convert::#{file_service}".constantize.new
            converted = file_converter.convert(uploaded)
            return false if converted.nil?

            translator = Translate::TranslateService.new(task: task)
            translated = translator.translate(data: converted.words_for_translate)
            return false if translated.nil?

            file_saver = "FileHandle::Save::#{file_service}".constantize.new(task: task)
            file_saver.save(data: translated)
        end
    end
end

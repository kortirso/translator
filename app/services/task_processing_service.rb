# Steps of processing for task
class TaskProcessingService
  attr_reader :task

  def initialize(args = {})
    @task = args[:task]
  end

  def call
    # uploading data from file
    uploaded = file_uploader.load
    # converting data for translation
    file_converter.convert(uploaded)
    # save temporary file with rebuilded data
    file_saver.save_temporary(file_converter.temporary)
    # translate data
    translator = Translate::TaskService.new(task: task)
    translator.translate(data: file_converter.words_for_translate)
    # save result file with trnslated data
    file_saver.save_result(data: file_converter.words_for_translate, translated: translator.translated)
  rescue StandardError => ex
    task.failure(ex.message.to_i)
  rescue
    task.failure(103)
  end

  # private section
  private def file_uploader
    @file_uploader ||= service('Upload')
  end

  private def file_converter
    @file_converter ||= service('Convert')
  end

  private def file_saver
    @file_saver ||= service('Save')
  end

  private def service(type)
    "FileHandle::#{type}::#{file_service}".constantize.new(task: task)
  end

  private def file_service
    @file_service ||= Checks::FileresponderService.call(task)
  end
end

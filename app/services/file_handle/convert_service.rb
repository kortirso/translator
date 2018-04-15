module FileHandle
  # Base class for converting files
  class ConvertService
    attr_reader :task, :words_for_translate, :fragment_service, :temporary

    def initialize(args = {})
      @task = args[:task]
      @words_for_translate = []
      @fragment_service = "FileHandle::Fragment::#{file_service}".constantize.new(task: task)
      post_initialize(args)
    end

    # subclasses may override
    private def post_initialize(_args)
      nil
    end

    private def file_service
      Checks::FileresponderService.call(task)
    end
  end
end

module Checks
  # Returns fileresponder's class
  class FileresponderService
    class << self
      def call(task)
        extension = task.file_name.split('.').last
        return task.framework.service if extension == task.framework.extension
        raise StandardError, 102
      end
    end
  end
end

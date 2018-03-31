module FileHandle
  # Base class for saving files
  class SaveService
    attr_reader :task

    def initialize(args = {})
      @task = args[:task]
      post_initialize(args)
    end

    def save_result(args = {})
      temporary_text = File.read(task.temporary_file.file.file)
      args[:data].uniq.each_with_index { |word, index| temporary_text.gsub!("_###{word}##_", args[:translated][index]) }
      save_result_file(temp_file_for_result, temporary_text)
      File.delete(temp_file_for_result)
    end

    # subclasses may override
    private def post_initialize(_args)
      nil
    end

    # subclasses may override
    private def temporary_file_name
      nil
    end

    private def temp_file_for_result
      file_name = task.temporary_file.file.file.split('/')[-1]
      "#{Rails.root}/public/uploads/tmp/#{file_name}"
    end

    private def save_result_file(file_name, temporary_text)
      File.open(file_name, 'w') do |f|
        f.write(temporary_text)
        task.result_file = f
      end
      task.status = 'done'
      task.save
    end
  end
end

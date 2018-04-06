module FileHandle
  # Base class for saving files
  class SaveService
    attr_reader :task

    def initialize(args = {})
      @task = args[:task]
    end

    def save_temporary(temporary)
      File.write(temporary_file_name, temporary)
      task.save_temporary_file(temporary_file_name)
    end

    def save_result(args = {})
      temporary_text = File.read(task.temporary_file.file.file)
      args[:data].uniq.each_with_index { |word, index| temporary_text.gsub!("_###{word}##_", args[:translated][index]) }
      save_result_file(result_file_name, temporary_text)
      File.delete(result_file_name)
    end

    private def temporary_file_name
      @temporary_file_name ||= define_temp_filename
    end

    private def result_file_name
      @result_file_name ||= define_result_filename
    end

    private def define_result_filename
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

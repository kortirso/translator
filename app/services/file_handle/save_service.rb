module FileHandle
  # Base class for saving files
  class SaveService
    TEMP_FOLDER = "#{Rails.root}/public/uploads/tmp/".freeze

    attr_reader :task

    def initialize(args = {})
      @task = args[:task]
    end

    def save_temporary(args = {})
      task.save_file(temporary_file_name, args[:data], 'temporary')
    end

    def save_result(args = {})
      task.save_file(result_file_name, prepare_results(args), 'result')
    end

    private def prepare_results(args)
      if task.temporary_file_name != ''
        text = File.read(task.temporary_file_name)
        args[:data].uniq.each_with_index { |word, index| text.gsub!("_###{word}##_", args[:translated][index]) }
        text
      else
        ''
      end
    end

    private def temporary_file_name
      @temporary_file_name ||= define_filename('temp')
    end

    private def result_file_name
      @result_file_name ||= define_filename('result')
    end
  end
end

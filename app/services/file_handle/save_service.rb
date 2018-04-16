module FileHandle
  # Base class for saving files
  class SaveService
    TEMP_FOLDER = "#{Rails.root}/public/uploads/tmp/".freeze

    attr_reader :task, :locale_to

    def initialize(args = {})
      @task = args[:task]
      @locale_to = Locale.find_by(code: task.to)
    end

    def save_temporary(args = {})
      task.save_file(temporary_file_name, args[:data], 'temporary')
    end

    def save_result
      task.save_file(result_file_name, prepare_results, 'result')
    end

    private def prepare_results
      text = task.temporary_file_content
      task.phrases.each do |phrase|
        text.gsub!("_###{phrase.id}##_", phrase.word.select_translations(locale: locale_to))
      end
      text
    end

    private def temporary_file_name
      @temporary_file_name ||= define_filename('temp')
    end

    private def result_file_name
      @result_file_name ||= define_filename('result')
    end
  end
end

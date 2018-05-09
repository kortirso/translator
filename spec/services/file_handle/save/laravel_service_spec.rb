RSpec.describe FileHandle::Save::LaravelService do
  let!(:framework) { create :laravel_framework }
  let!(:task) { create :task, :with_json_keyed, framework: framework }
  let(:saver) { FileHandle::Save::LaravelService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(saver.task).to eq task
    end
  end

  describe '.temporary_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:temporary_file_name)).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.temp.#{task.to}.json"
    end
  end

  describe '.result_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:result_file_name)).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.result.#{task.to}.json"
    end
  end

  describe '.define_filename' do
    context 'for temporary file' do
      it 'returns new temp file name with locale' do
        expect(saver.send(:define_filename, 'temp')).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.temp.#{task.to}.json"
      end
    end

    context 'for result file' do
      it 'returns new result file name with locale' do
        expect(saver.send(:define_filename, 'result')).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.result.#{task.to}.json"
      end
    end
  end
end

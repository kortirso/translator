RSpec.describe FileHandle::Save::RailsService do
  let!(:framework) { create :rails_framework }
  let!(:task) { create :task, :with_yml, framework: framework }
  let(:saver) { FileHandle::Save::RailsService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(saver.task).to eq task
    end
  end

  describe '.save_temporary' do
    it 'calls save_file for task with temporary type' do
      expect(task).to receive(:save_file)

      saver.save_temporary(data: '1')
    end
  end

  describe '.temporary_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:temporary_file_name)).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.temp.en.yml"
    end
  end

  describe '.result_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:result_file_name)).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.result.en.yml"
    end
  end

  describe '.define_filename' do
    context 'for temporary file' do
      it 'returns new temp file name with locale' do
        expect(saver.send(:define_filename, 'temp')).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.temp.en.yml"
      end
    end

    context 'for result file' do
      it 'returns new result file name with locale' do
        expect(saver.send(:define_filename, 'result')).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.result.en.yml"
      end
    end
  end
end

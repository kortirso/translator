RSpec.describe FileHandle::Save::YiiService do
  let!(:framework) { create :yii_framework }
  let!(:task) { create :task, :with_php, framework: framework }
  let(:saver) { FileHandle::Save::YiiService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(saver.task).to eq task
    end
  end

  describe '.temporary_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:temporary_file_name)).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.temp.app.#{task.to}.php"
    end
  end

  describe '.result_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:result_file_name)).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.result.app.#{task.to}.php"
    end
  end

  describe '.define_filename' do
    context 'for temporary file' do
      it 'returns new temp file name with locale' do
        expect(saver.send(:define_filename, 'temp')).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.temp.app.#{task.to}.php"
      end
    end

    context 'for result file' do
      it 'returns new result file name with locale' do
        expect(saver.send(:define_filename, 'result')).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.result.app.#{task.to}.php"
      end
    end
  end
end

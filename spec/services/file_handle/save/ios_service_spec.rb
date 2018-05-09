RSpec.describe FileHandle::Save::IosService do
  let!(:framework) { create :ios_framework }
  let!(:task) { create :task, :with_strings, framework: framework }
  let(:saver) { FileHandle::Save::IosService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(saver.task).to eq task
    end
  end

  describe '.temporary_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:temporary_file_name)).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.temp.Main.#{task.to}.strings"
    end
  end

  describe '.result_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:result_file_name)).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.result.Main.#{task.to}.strings"
    end
  end

  describe '.define_filename' do
    context 'for temporary file' do
      it 'returns new temp file name with locale' do
        expect(saver.send(:define_filename, 'temp')).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.temp.Main.#{task.to}.strings"
      end
    end

    context 'for result file' do
      it 'returns new result file name with locale' do
        expect(saver.send(:define_filename, 'result')).to eq "#{FileHandle::SaveService::TEMP_FOLDER}#{task.id}.result.Main.#{task.to}.strings"
      end
    end
  end
end

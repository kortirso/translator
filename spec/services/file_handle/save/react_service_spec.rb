RSpec.describe FileHandle::Save::ReactService do
  let!(:framework) { create :react_framework }
  let!(:task) { create :task, :with_json, framework: framework }
  let(:saver) { FileHandle::Save::ReactService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(saver.task).to eq task
    end
  end

  describe '.temporary_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:temporary_file_name)).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.temp.data.json"
    end
  end

  describe '.result_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:result_file_name)).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.result.data.json"
    end
  end

  describe '.define_filename' do
    context 'for temporary file' do
      it 'returns new temp file name with locale' do
        expect(saver.send(:define_filename, 'temp')).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.temp.data.json"
      end
    end

    context 'for result file' do
      it 'returns new result file name with locale' do
        expect(saver.send(:define_filename, 'result')).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.result.data.json"
      end
    end
  end
end

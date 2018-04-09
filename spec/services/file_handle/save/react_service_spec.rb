RSpec.describe FileHandle::Save::ReactService do
  let!(:framework) { create :react_framework }
  let!(:task) { create :task, :with_json, framework: framework, to: 'en' }
  let(:saver) { FileHandle::Save::ReactService.new(task: task) }

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

  describe '.temporary_hash' do
    let(:args) { { data: { hello: 'Hello' } } }

    it 'adds data to base hash' do
      result = saver.send(:temporary_hash, args)

      expect(result.is_a?(Hash)).to eq true
      expect(result.keys.size).to eq 2
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

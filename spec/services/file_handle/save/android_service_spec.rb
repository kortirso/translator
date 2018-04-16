RSpec.describe FileHandle::Save::AndroidService do
  let!(:locale) { create :locale, :ru }
  let!(:locale) { create :locale, :en }
  let!(:framework) { create :android_framework }
  let!(:task) { create :task, :with_xml, framework: framework, from: 'ru' }
  let(:saver) { FileHandle::Save::AndroidService.new(task: task) }

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

  describe '.save_result' do
    let(:loader) { FileHandle::Upload::AndroidService.new(task: task) }
    let(:converter) { FileHandle::Convert::AndroidService.new(task: task) }

    it 'calls save_file for task with result type' do
      expect(task).to receive(:save_file)

      uploaded = loader.load
      converter.convert(uploaded)
      task.reload

      saver.save_result
    end
  end

  describe '.temporary_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:temporary_file_name)).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.temp.strings.#{task.to}.xml"
    end
  end

  describe '.result_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:result_file_name)).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.result.strings.#{task.to}.xml"
    end
  end

  describe '.define_filename' do
    context 'for temporary file' do
      it 'returns new temp file name with locale' do
        expect(saver.send(:define_filename, 'temp')).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.temp.strings.#{task.to}.xml"
      end
    end

    context 'for result file' do
      it 'returns new result file name with locale' do
        expect(saver.send(:define_filename, 'result')).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.result.strings.#{task.to}.xml"
      end
    end
  end
end

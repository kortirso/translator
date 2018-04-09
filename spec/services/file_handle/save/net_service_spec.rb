RSpec.describe FileHandle::Save::NetService do
  let!(:framework) { create :net_framework }
  let!(:locale) { create :locale, :ru }
  let!(:task) { create :task, :with_resx, framework: framework, to: 'ru' }
  let(:saver) { FileHandle::Save::NetService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(saver.task).to eq task
    end
  end

  describe '.temporary_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:temporary_file_name)).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.temp.UIStrings.ru-RU.resx"
    end
  end

  describe '.result_file_name' do
    it 'returns new file name with locale' do
      expect(saver.send(:result_file_name)).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.result.UIStrings.ru-RU.resx"
    end
  end

  describe '.define_filename' do
    context 'for temporary file' do
      it 'returns new temp file name with locale' do
        expect(saver.send(:define_filename, 'temp')).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.temp.UIStrings.ru-RU.resx"
      end
    end

    context 'for result file' do
      it 'returns new result file name with locale' do
        expect(saver.send(:define_filename, 'result')).to eq "#{Rails.root}/public/uploads/tmp/#{task.id}.result.UIStrings.ru-RU.resx"
      end
    end
  end
end

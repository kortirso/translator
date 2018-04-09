RSpec.describe TaskProcessingService, type: :service do
  let!(:framework) { create :android_framework }
  let!(:task) { create :task, :with_locale_xml, framework: framework }
  let(:processor) { TaskProcessingService.new(task: task) }

  describe '.file_uploader' do
    it 'returns uploader for current framework' do
      expect(processor.send(:file_uploader).is_a?(FileHandle::Upload::AndroidService)).to eq true
    end
  end

  describe '.file_converter' do
    it 'returns converter for current framework' do
      expect(processor.send(:file_converter).is_a?(FileHandle::Convert::AndroidService)).to eq true
    end
  end

  describe '.file_saver' do
    it 'returns saver for current framework' do
      expect(processor.send(:file_saver).is_a?(FileHandle::Save::AndroidService)).to eq true
    end
  end

  describe '.translator' do
    it 'returns translator object' do
      expect(processor.send(:translator).is_a?(Translate::TaskService)).to eq true
    end
  end

  describe '.service' do
    it 'returns object of specific sub service' do
      expect(processor.send(:service, 'Save').is_a?(FileHandle::Save::AndroidService)).to eq true
    end
  end

  describe '.file_service' do
    it 'returns service name for sub services' do
      expect(processor.send(:file_service)).to eq framework.service
    end
  end
end

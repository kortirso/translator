RSpec.describe TaskProcessingService, type: :service do
  let!(:framework) { create :android_framework }
  let!(:task) { create :task, :with_locale_xml, framework: framework }
  let(:processor) { TaskProcessingService.new(task: task) }

  describe 'methods' do
    context '.call' do
      it 'calls upload method for uploader' do
        expect_any_instance_of(FileHandle::Upload::AndroidService).to receive(:load)

        processor.call
      end

      it 'and calls convert method for converter' do
        expect_any_instance_of(FileHandle::Convert::AndroidService).to receive(:convert)

        processor.call
      end

      it 'and does not raise error for valid task' do
        expect { processor.call }.to_not raise_error
      end
    end

    context '.file_uploader' do
      it 'returns uploader for current framework' do
        expect(processor.send(:file_uploader).is_a?(FileHandle::Upload::AndroidService)).to eq true
      end
    end

    context '.file_converter' do
      it 'returns converter for current framework' do
        expect(processor.send(:file_converter).is_a?(FileHandle::Convert::AndroidService)).to eq true
      end
    end

    context '.file_saver' do
      it 'returns saver for current framework' do
        expect(processor.send(:file_saver).is_a?(FileHandle::Save::AndroidService)).to eq true
      end
    end

    context '.translator' do
      it 'returns translator object' do
        expect(processor.send(:translator).is_a?(Translate::TaskService)).to eq true
      end
    end

    context '.service' do
      it 'returns object of specific sub service' do
        expect(processor.send(:service, 'Save').is_a?(FileHandle::Save::AndroidService)).to eq true
      end
    end

    context '.file_service' do
      it 'returns service name for sub services' do
        expect(processor.send(:file_service)).to eq framework.service
      end
    end
  end
end

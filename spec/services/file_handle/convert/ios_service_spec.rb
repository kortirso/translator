RSpec.describe FileHandle::Convert::IosService do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :ios_framework }
  let!(:task) { create :task, :with_strings, framework: framework, from: 'ru' }
  let(:converter) { FileHandle::Convert::IosService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(converter.task).to eq task
    end

    it 'and assigns FileHandle::Fragment::IosService to @fragment_service' do
      expect(converter.fragment_service.is_a?(FileHandle::Fragment::IosService)).to eq true
    end
  end

  describe 'methods' do
    let(:loader) { FileHandle::Upload::IosService.new(task: task) }
    let(:uploaded) { loader.load }

    describe '.convert' do
      before { converter.convert(uploaded) }

      it 'saves temporary data in temporary' do
        expect(converter.temporary.is_a?(String)).to eq true
      end
    end
  end
end

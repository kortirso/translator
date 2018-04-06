RSpec.describe FileHandle::Convert::IosService do
  describe '.initialize' do
    let!(:framework) { create :ios_framework }
    let!(:task) { create :task, :with_strings, framework: framework }
    let(:loader) { FileHandle::Convert::IosService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end

    it 'and assigns [] to @words_for_translate' do
      expect(loader.words_for_translate).to eq []
    end

    it 'and assigns FileHandle::Fragment::IosService to @fragment_service' do
      expect(loader.fragment_service.is_a?(FileHandle::Fragment::IosService)).to eq true
    end
  end
end

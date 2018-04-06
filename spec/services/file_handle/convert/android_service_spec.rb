RSpec.describe FileHandle::Convert::AndroidService do
  describe '.initialize' do
    let!(:framework) { create :android_framework }
    let!(:task) { create :task, :with_xml, framework: framework }
    let(:loader) { FileHandle::Convert::AndroidService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end

    it 'and assigns [] to @words_for_translate' do
      expect(loader.words_for_translate).to eq []
    end

    it 'and assigns FileHandle::Fragment::AndroidService to @fragment_service' do
      expect(loader.fragment_service.is_a?(FileHandle::Fragment::AndroidService)).to eq true
    end
  end
end

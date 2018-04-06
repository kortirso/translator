RSpec.describe FileHandle::Convert::NetService do
  describe '.initialize' do
    let!(:framework) { create :net_framework }
    let!(:task) { create :task, :with_resx, framework: framework }
    let(:loader) { FileHandle::Convert::NetService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end

    it 'and assigns [] to @words_for_translate' do
      expect(loader.words_for_translate).to eq []
    end

    it 'and assigns FileHandle::Fragment::NetService to @fragment_service' do
      expect(loader.fragment_service.is_a?(FileHandle::Fragment::NetService)).to eq true
    end
  end
end

RSpec.describe FileHandle::Convert::ReactService do
  describe '.initialize' do
    let!(:framework) { create :react_framework }
    let!(:task) { create :task, :with_json, framework: framework }
    let(:loader) { FileHandle::Convert::ReactService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end

    it 'and assigns [] to @words_for_translate' do
      expect(loader.words_for_translate).to eq []
    end

    it 'and assigns FileHandle::Fragment::ReactService to @fragment_service' do
      expect(loader.fragment_service.is_a?(FileHandle::Fragment::ReactService)).to eq true
    end
  end
end

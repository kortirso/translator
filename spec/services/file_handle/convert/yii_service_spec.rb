RSpec.describe FileHandle::Convert::YiiService do
  describe '.initialize' do
    let!(:framework) { create :yii_framework }
    let!(:task) { create :task, :with_php, framework: framework }
    let(:loader) { FileHandle::Convert::YiiService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end

    it 'and assigns [] to @words_for_translate' do
      expect(loader.words_for_translate).to eq []
    end

    it 'and assigns FileHandle::Fragment::YiiService to @fragment_service' do
      expect(loader.fragment_service.is_a?(FileHandle::Fragment::YiiService)).to eq true
    end
  end
end

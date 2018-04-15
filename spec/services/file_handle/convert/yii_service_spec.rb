RSpec.describe FileHandle::Convert::YiiService do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :yii_framework }
  let!(:task) { create :task, :with_php, framework: framework, from: 'ru' }
  let(:converter) { FileHandle::Convert::YiiService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(converter.task).to eq task
    end

    it 'and assigns [] to @words_for_translate' do
      expect(converter.words_for_translate).to eq []
    end

    it 'and assigns FileHandle::Fragment::YiiService to @fragment_service' do
      expect(converter.fragment_service.is_a?(FileHandle::Fragment::YiiService)).to eq true
    end
  end
end

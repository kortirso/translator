RSpec.describe FileHandle::Fragment::YiiService, type: :service do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :yii_framework }
  let!(:task) { create :task, :with_php, framework: framework, from: 'ru' }
  let(:fragmenter) { FileHandle::Fragment::YiiService.new(task: task) }

  describe '.perform_phrase' do
    context 'for phrase' do
      let(:phrase) { 'Page not found' }

      it 'returns modified sentence and array for translate' do
        answer = fragmenter.perform_phrase(phrase)

        expect(answer[:sentence]).to eq '_##Page not found##_'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end
  end
end

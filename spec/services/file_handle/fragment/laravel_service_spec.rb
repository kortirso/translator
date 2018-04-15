RSpec.describe FileHandle::Fragment::LaravelService, type: :service do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :laravel_framework }
  let!(:task) { create :task, :with_json_keyed, framework: framework, from: 'ru' }
  let(:fragmenter) { FileHandle::Fragment::LaravelService.new(task: task) }

  describe '.perform_phrase' do
    context 'for sentence' do
      let(:sentence) { 'Page not found' }

      it 'returns modified sentence and array for translate' do
        answer = fragmenter.perform_phrase(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end
  end
end

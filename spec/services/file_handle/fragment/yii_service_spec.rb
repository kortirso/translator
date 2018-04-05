RSpec.describe FileHandle::Fragment::YiiService, type: :service do
  describe '.perform_phrase' do
    let(:sentence_checker) { FileHandle::Fragment::YiiService.new }

    context 'for phrase' do
      let(:phrase) { 'Page not found' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_checker.perform_phrase(phrase)

        expect(answer[:sentence]).to eq '_##Page not found##_'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end
  end
end

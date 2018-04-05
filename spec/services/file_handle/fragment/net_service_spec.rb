RSpec.describe FileHandle::Fragment::NetService, type: :service do
  describe '.perform_phrase' do
    let(:sentence_checker) { FileHandle::Fragment::NetService.new }

    context 'for sentence' do
      let(:sentence) { 'Page not found' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_checker.perform_phrase(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end
  end
end

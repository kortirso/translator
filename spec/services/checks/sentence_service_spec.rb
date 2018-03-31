RSpec.describe Checks::SentenceService, type: :service do
  let(:sentence_service) { Checks::SentenceService.new(:yml) }

  describe '.call' do
    context 'for simple sentence without dot' do
      let(:sentence) { 'Page not found' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.call(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end

    context 'for simple sentence with dot' do
      let(:sentence) { 'Page not found.' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.call(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_.'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end

    context 'for 2 sentences with 1 dot' do
      let(:sentence) { 'Page not found. 1' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.call(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_. _##1##_'
        expect(answer[:blocks_for_translate]).to eq ['Page not found', '1']
      end
    end

    context 'for 2 sentences with 2 dots' do
      let(:sentence) { 'Page not found. 1.' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.call(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_. _##1##_.'
        expect(answer[:blocks_for_translate]).to eq ['Page not found', '1']
      end
    end

    context 'for 2 sentences with 2 dots with tags and variables' do
      let(:sentence) { "You are using an <strong>outdated</strong> browser. Please <a href='https://browsehappy.com/'>upgrade your browser</a> to %{improve} your experience." }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.call(sentence)

        expect(answer[:sentence]).to eq "_##You are using an##_ <strong>_##outdated##_</strong> _##browser##_. _##Please##_ <a href='https://browsehappy.com/'>_##upgrade your browser##_</a> _##to##_ %{improve} _##your experience##_."
        expect(answer[:blocks_for_translate]).to eq ['You are using an', 'outdated', 'browser', 'Please', 'upgrade your browser', 'to', 'your experience']
      end
    end
  end

  describe '.sentence_splitter' do
    context 'for simple sentence without dot' do
      let(:sentence) { 'Page not found' }

      it 'returns sentence in array without dot' do
        answer = sentence_service.send(:sentence_splitted_by_dot, sentence)

        expect(answer).to eq [sentence]
      end
    end

    context 'for simple sentence with dot' do
      let(:sentence) { 'Page not found.' }

      it 'returns sentence in array with dot' do
        answer = sentence_service.send(:sentence_splitted_by_dot, sentence)

        expect(answer).to eq ['Page not found']
      end
    end

    context 'for 2 sentences with 1 dot' do
      let(:sentence) { 'Page not found. 1' }

      it 'returns sentences in array with 1 dot' do
        answer = sentence_service.send(:sentence_splitted_by_dot, sentence)

        expect(answer).to eq ['Page not found', ' 1']
      end
    end

    context 'for 2 sentences with 2 dots' do
      let(:sentence) { 'Page not found. 1.' }

      it 'returns sentences in array with 2 dots' do
        answer = sentence_service.send(:sentence_splitted_by_dot, sentence)

        expect(answer).to eq ['Page not found', ' 1']
      end
    end

    context 'for 2 sentences with 2 dots and link tag with dot' do
      let(:sentence) { "You are using an <strong>outdated</strong> browser. Please <a href='https://browsehappy.com/'>upgrade your browser</a> to %{improve} your experience." }

      it 'returns sentences in array with 2 dots' do
        answer = sentence_service.send(:sentence_splitted_by_dot, sentence)

        expect(answer).to eq ['You are using an <strong>outdated</strong> browser', " Please <a href='https://browsehappy.com/'>upgrade your browser</a> to %{improve} your experience"]
      end
    end
  end
end

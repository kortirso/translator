RSpec.describe FileHandle::Fragment::RailsService, type: :service do
  let(:sentence_service) { FileHandle::Fragment::RailsService.new }

  describe '.perform_sentence' do
    context 'for simple sentence without dot' do
      let(:sentence) { 'Page not found' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.perform_sentence(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end

    context 'for simple sentence with dot' do
      let(:sentence) { 'Page not found.' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.perform_sentence(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_.'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end

    context 'for 2 sentences with 1 dot' do
      let(:sentence) { 'Page not found. 1' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.perform_sentence(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_. _##1##_'
        expect(answer[:blocks_for_translate]).to eq ['Page not found', '1']
      end
    end

    context 'for 2 sentences with 2 dots' do
      let(:sentence) { 'Page not found. 1.' }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.perform_sentence(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_. _##1##_.'
        expect(answer[:blocks_for_translate]).to eq ['Page not found', '1']
      end
    end

    context 'for 2 sentences with 2 dots with tags and variables' do
      let(:sentence) { "You are using an <strong>outdated</strong> browser. Please <a href='https://browsehappy.com/'>upgrade your browser</a> to %{improve} your experience." }

      it 'returns modified sentence and array for translate' do
        answer = sentence_service.perform_sentence(sentence)

        expect(answer[:sentence]).to eq "_##You are using an##_ <strong>_##outdated##_</strong> _##browser##_. _##Please##_ <a href='https://browsehappy.com/'>_##upgrade your browser##_</a> _##to##_ %{improve} _##your experience##_."
        expect(answer[:blocks_for_translate]).to eq ['You are using an', 'outdated', 'browser', 'Please', 'upgrade your browser', 'to', 'your experience']
      end
    end
  end

  describe '.sentence_splitted_by_dot' do
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

  describe '.perform_phrase' do
    let(:sentence_checker) { FileHandle::Fragment::RailsService.new }

    context 'for sentence with 1 variable' do
      let(:sentence) { 'Page not found, %{name}' }

      it 'returns modified sentence and array for translate with untranslated variables' do
        answer = sentence_checker.perform_phrase(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_, %{name}'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end

    context 'for sentence with 2 variables' do
      let(:sentence) { '%{name_1}, Page not found, %{name_2}' }

      it 'returns modified sentence and array for translate with untranslated variables' do
        answer = sentence_checker.perform_phrase(sentence)

        expect(answer[:sentence]).to eq '%{name_1}, _##Page not found##_, %{name_2}'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end

    context 'for sentence with tag' do
      let(:sentence) { 'You are using an <strong>outdated</strong> browser' }

      it 'returns modified sentence and array for translate with untranslated tags' do
        answer = sentence_checker.perform_phrase(sentence)

        expect(answer[:sentence]).to eq '_##You are using an##_ <strong>_##outdated##_</strong> _##browser##_'
        expect(answer[:blocks_for_translate]).to eq ['You are using an', 'outdated', 'browser']
      end
    end

    context 'for sentence with special characters' do
      let(:sentence) { 'You are using an <strong>outdated &amp;</strong> browser' }

      it 'returns modified sentence and array for translate with untranslated tags and special characters' do
        answer = sentence_checker.perform_phrase(sentence)

        expect(answer[:sentence]).to eq '_##You are using an##_ <strong>_##outdated##_ &amp;</strong> _##browser##_'
        expect(answer[:blocks_for_translate]).to eq ['You are using an', 'outdated', 'browser']
      end
    end

    context 'for sentence with formatters' do
      let(:sentence) { '%m/%d/%Y' }

      it 'returns modified sentence and array for translate with untranslated formatters' do
        answer = sentence_checker.perform_phrase(sentence)

        expect(answer[:sentence]).to eq '%m/%d/%Y'
        expect(answer[:blocks_for_translate]).to eq []
      end
    end
  end
end

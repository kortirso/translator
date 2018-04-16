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

  describe '.sentence_splitted_by_dot' do
    context 'for simple sentence without dot' do
      let(:sentence) { 'Page not found' }

      it 'returns sentence in array without dot' do
        answer = fragmenter.send(:sentence_splitted_by_dot, sentence)

        expect(answer).to eq [sentence]
      end
    end

    context 'for simple sentence with dot' do
      let(:sentence) { 'Page not found.' }

      it 'returns sentence in array with dot' do
        answer = fragmenter.send(:sentence_splitted_by_dot, sentence)

        expect(answer).to eq ['Page not found']
      end
    end

    context 'for 2 sentences with 1 dot' do
      let(:sentence) { 'Page not found. 1' }

      it 'returns sentences in array with 1 dot' do
        answer = fragmenter.send(:sentence_splitted_by_dot, sentence)

        expect(answer).to eq ['Page not found', ' 1']
      end
    end

    context 'for 2 sentences with 2 dots' do
      let(:sentence) { 'Page not found. 1.' }

      it 'returns sentences in array with 2 dots' do
        answer = fragmenter.send(:sentence_splitted_by_dot, sentence)

        expect(answer).to eq ['Page not found', ' 1']
      end
    end
  end
end

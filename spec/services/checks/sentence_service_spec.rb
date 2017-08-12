RSpec.describe Checks::SentenceService, type: :service do
    describe '.call' do
        context 'for simple sentence without dot' do
            let(:sentence) { 'Page not found' }

            it 'returns modified sentence and array for translate' do
                answer = Checks::SentenceService.call(sentence, :yml)

                expect(answer[:sentence]).to eq '_##Page not found##_'
                expect(answer[:blocks_for_translate]).to eq ['Page not found']
            end
        end

        context 'for simple sentence with dot' do
            let(:sentence) { 'Page not found.' }

            it 'returns modified sentence and array for translate' do
                answer = Checks::SentenceService.call(sentence, :yml)

                expect(answer[:sentence]).to eq '_##Page not found##_.'
                expect(answer[:blocks_for_translate]).to eq ['Page not found']
            end
        end

        context 'for 2 sentences with 1 dot' do
            let(:sentence) { 'Page not found. 1' }

            it 'returns modified sentence and array for translate' do
                answer = Checks::SentenceService.call(sentence, :yml)

                expect(answer[:sentence]).to eq '_##Page not found##_._## 1##_'
                expect(answer[:blocks_for_translate]).to eq ['Page not found', ' 1']
            end
        end

        context 'for 2 sentences with 2 dots' do
            let(:sentence) { 'Page not found. 1.' }

            it 'returns modified sentence and array for translate' do
                answer = Checks::SentenceService.call(sentence, :yml)

                expect(answer[:sentence]).to eq '_##Page not found##_._## 1##_.'
                expect(answer[:blocks_for_translate]).to eq ['Page not found', ' 1']
            end
        end
    end

    describe '.sentence_splitter' do
        context 'for simple sentence without dot' do
            let(:sentence) { 'Page not found' }

            it 'returns sentence in array without dot' do
                answer = Checks::SentenceService.sentence_splitter(sentence)

                expect(answer).to eq [sentence]
            end
        end

        context 'for simple sentence with dot' do
            let(:sentence) { 'Page not found.' }

            it 'returns sentence in array with dot' do
                answer = Checks::SentenceService.sentence_splitter(sentence)

                expect(answer).to eq ['Page not found']
            end
        end

        context 'for 2 sentences with 1 dot' do
            let(:sentence) { 'Page not found. 1' }

            it 'returns sentences in array with 1 dot' do
                answer = Checks::SentenceService.sentence_splitter(sentence)

                expect(answer).to eq ['Page not found', ' 1']
            end
        end

        context 'for 2 sentences with 2 dots' do
            let(:sentence) { 'Page not found. 1.' }

            it 'returns sentences in array with 2 dots' do
                answer = Checks::SentenceService.sentence_splitter(sentence)

                expect(answer).to eq ['Page not found', ' 1']
            end
        end
    end
end

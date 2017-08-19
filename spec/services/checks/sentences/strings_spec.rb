RSpec.describe Checks::Sentences::Strings, type: :service do
    describe '.call' do
        let(:sentence_checker) { Checks::Sentences::Strings.new }

        context 'for sentence' do
            let(:sentence) { 'Page not found' }

            it 'returns modified sentence and array for translate' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '_##Page not found##_'
                expect(answer[:blocks_for_translate]).to eq ['Page not found']
            end
        end

        context 'for sentence with formatter' do
            let(:sentence) { '%d file(s) remaining' }

            it 'returns modified sentence and array for translate without formatter' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '%d _##file(s) remaining##_'
                expect(answer[:blocks_for_translate]).to eq ['file(s) remaining']
            end
        end
    end
end

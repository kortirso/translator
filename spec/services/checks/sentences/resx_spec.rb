RSpec.describe Checks::Sentences::Resx, type: :service do
    describe '.call' do
        let(:sentence_checker) { Checks::Sentences::Resx.new }

        context 'for sentence' do
            let(:sentence) { 'Page not found' }

            it 'returns modified sentence and array for translate' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '_##Page not found##_'
                expect(answer[:blocks_for_translate]).to eq ['Page not found']
            end
        end
    end
end

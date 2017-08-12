RSpec.describe Checks::Sentences::Resx, type: :service do
    describe '.call' do
        context 'for sentence' do
            let(:sentence) { 'Page not found' }

            it 'returns modified sentence and array for translate' do
                answer = Checks::Sentences::Resx.call(sentence)

                expect(answer[:sentence]).to eq '_##Page not found##_'
                expect(answer[:blocks_for_translate]).to eq ['Page not found']
            end
        end
    end
end

RSpec.describe Checks::Sentences::Xml, type: :service do
    describe '.call' do
        let(:sentence_checker) { Checks::Sentences::Xml.new }

        context 'for simple sentence' do
            let(:sentence) { 'Page not found' }

            it 'returns modified sentence and array for translate' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '_##Page not found##_'
                expect(answer[:blocks_for_translate]).to eq ['Page not found']
            end
        end

        context 'for sentence with variable' do
            let(:sentence) { 'Please use the "<xliff:g id="promotion_code">ABCDEFG</xliff:g>" to get a discount' }

            it 'returns modified sentence and array for translate' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '_##Please use the##_ "<xliff:g id="promotion_code">ABCDEFG</xliff:g>" _##to get a discount##_'
                expect(answer[:blocks_for_translate]).to eq ['Please use the', 'to get a discount']
            end
        end

        context 'for sentence with variable and special symbols' do
            let(:sentence) { 'Please use the "<xliff:g id="promotion_code">ABCDEFG</xliff:g>" to get a &amp; discount' }

            it 'returns modified sentence and array for translate' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '_##Please use the##_ "<xliff:g id="promotion_code">ABCDEFG</xliff:g>" _##to get a##_ &amp; _##discount##_'
                expect(answer[:blocks_for_translate]).to eq ['Please use the', 'to get a', 'discount']
            end
        end

        context 'for sentence with 2 variables' do
            let(:sentence) { 'Please use the "<xliff:g id="promotion_code">ABCDEFG</xliff:g>" to get a <xliff:g id="promotion_code">ABCDEFG</xliff:g> discount' }

            it 'returns modified sentence and array for translate' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '_##Please use the##_ "<xliff:g id="promotion_code">ABCDEFG</xliff:g>" _##to get a##_ <xliff:g id="promotion_code">ABCDEFG</xliff:g> _##discount##_'
                expect(answer[:blocks_for_translate]).to eq ['Please use the', 'to get a', 'discount']
            end
        end
    end
end

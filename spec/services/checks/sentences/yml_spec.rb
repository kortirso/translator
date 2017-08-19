RSpec.describe Checks::Sentences::Yml, type: :service do
    describe '.call' do
        let(:sentence_checker) { Checks::Sentences::Yml.new }

        context 'for sentence with 1 variable' do
            let(:sentence) { 'Page not found, %{name}' }

            it 'returns modified sentence and array for translate with untranslated variables' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '_##Page not found##_, %{name}'
                expect(answer[:blocks_for_translate]).to eq ['Page not found']
            end
        end

        context 'for sentence with 2 variables' do
            let(:sentence) { '%{name_1}, Page not found, %{name_2}' }

            it 'returns modified sentence and array for translate with untranslated variables' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '%{name_1}, _##Page not found##_, %{name_2}'
                expect(answer[:blocks_for_translate]).to eq ['Page not found']
            end
        end

        context 'for sentence with tag' do
            let(:sentence) { 'You are using an <strong>outdated</strong> browser' }

            it 'returns modified sentence and array for translate with untranslated tags' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '_##You are using an##_ <strong>_##outdated##_</strong> _##browser##_'
                expect(answer[:blocks_for_translate]).to eq ['You are using an', 'outdated', 'browser']
            end
        end

        context 'for sentence with special characters' do
            let(:sentence) { 'You are using an <strong>outdated &amp;</strong> browser' }

            it 'returns modified sentence and array for translate with untranslated tags and special characters' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '_##You are using an##_ <strong>_##outdated##_ &amp;</strong> _##browser##_'
                expect(answer[:blocks_for_translate]).to eq ['You are using an', 'outdated', 'browser']
            end
        end

        context 'for sentence with formatters' do
            let(:sentence) { '%m/%d/%Y' }

            it 'returns modified sentence and array for translate with untranslated formatters' do
                answer = sentence_checker.call(sentence)

                expect(answer[:sentence]).to eq '%m/%d/%Y'
                expect(answer[:blocks_for_translate]).to eq []
            end
        end
    end
end

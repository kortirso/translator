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
    end
end

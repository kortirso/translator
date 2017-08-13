RSpec.describe RequestService, type: :service do
    describe '.initialize' do
        let(:requester) { RequestService.new(request: :get_langs, from: 'en') }

        it "should assign ENV['YANDEX_TRANSLATE_API_KEY'] to @api_key" do
            expect(requester.api_key).to eq ENV['YANDEX_TRANSLATE_API_KEY']
        end

        it 'should assign request to @request' do
            expect(requester.request).to eq :get_langs
        end

        it 'should assign uri to @uri' do
            expect(requester.uri).to_not eq nil
        end
    end

    describe '.call' do
        context 'for get_langs request' do
            let(:requester) { RequestService.new(request: :get_langs, from: 'en') }
            let(:answer) { requester.call }

            it 'returns list of possible translations in dirs' do
                expect(answer.is_a?(Hash)).to eq true
                expect(answer['dirs'].is_a?(Array)).to eq true
                expect(answer['dirs'].size.zero?).to eq false
            end

            it 'returns list of languages in langs' do
                expect(answer['langs'].is_a?(Hash)).to eq true
                expect(answer['langs'].size.zero?).to eq false
            end
        end

        context 'for translate request' do
            let(:requester) { RequestService.new(request: :translate, from: 'en', to: 'ru') }
            let(:answer) { requester.call('Hello') }

            it 'returns translation for word' do
                expect(answer).to eq 'Привет'
            end
        end
    end
end

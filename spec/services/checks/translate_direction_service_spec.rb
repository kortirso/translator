RSpec.describe Checks::TranslateDirectionService, type: :service do
    describe '.call' do
        context 'for valid locale' do
            let!(:locale) { create :locale, :ru }
            let!(:task) { create :task, from: 'ru' }

            it 'returns true' do
                stub_request(:post, 'https://translate.yandex.net/api/v1.5/tr.json/getLangs')
                    .to_return(status: 200, body: '{"dirs":["ru-en", "en-de"]}', headers: {})

                expect(Checks::TranslateDirectionService.call(task)).to eq true
            end
        end

        context 'for invalid locale' do
            context 'for incorrect locale code' do
                let(:task) { create :task, from: 'EN' }
                let(:request) { Checks::TranslateDirectionService.call(task) }

                it 'returns false' do
                    expect(request).to eq false
                end

                it 'executes failure method for task' do
                    expect_any_instance_of(Task).to receive(:failure)

                    request
                end

                it 'updates task with 203 failure code' do
                    request
                    task.reload

                    expect(task.error).to eq 203
                end
            end

            context 'for unexisted locale at Yandex' do
                let!(:locale) { create :locale, :en }
                let(:task) { create :task, from: 'en', to: 'pk' }
                let(:request) { Checks::TranslateDirectionService.call(task) }

                it 'returns false' do
                    stub_request(:post, 'https://translate.yandex.net/api/v1.5/tr.json/getLangs')
                        .to_return(status: 200, body: '{"dirs":["ru-en", "en-de"]}', headers: {})

                    expect(request).to eq false
                end

                it 'executes failure method for task' do
                    stub_request(:post, 'https://translate.yandex.net/api/v1.5/tr.json/getLangs')
                        .to_return(status: 200, body: '{"dirs":["ru-en", "en-de"]}', headers: {})
                    expect_any_instance_of(Task).to receive(:failure)

                    request
                end

                it 'updates task with 201 failure code' do
                    stub_request(:post, 'https://translate.yandex.net/api/v1.5/tr.json/getLangs')
                        .to_return(status: 200, body: '{"dirs":["ru-en", "en-de"]}', headers: {})

                    request
                    task.reload

                    expect(task.error).to eq 201
                end
            end
        end
    end
end

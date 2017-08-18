RSpec.describe Checks::TranslateDirectionService, type: :service do
    describe '.call' do
        context 'for valid locale' do
            let!(:locale) { create :locale, :ru }
            let!(:task) { create :task, from: 'ru' }

            it 'returns true' do
                expect(Checks::TranslateDirectionService.call(task)).to eq true
            end
        end

        context 'for invalid locale' do
            let(:task) { create :task, from: 'EN' }

            it 'returns false' do
                expect(Checks::TranslateDirectionService.call(task)).to eq false
            end

            it 'executes failure method for task' do
                expect_any_instance_of(Task).to receive(:failure)

                Checks::TranslateDirectionService.call(task)
            end
        end
    end
end

RSpec.describe Checks::TranslateDirectionService, type: :service do
    describe '.call' do
        context 'for valid task' do
            let!(:task) { create :task, from: 'ru' }

            it 'should return true' do
                expect(Checks::TranslateDirectionService.call(task)).to eq true
            end
        end

        context 'for invalid task' do
            let(:task) { create :task, from: '11' }

            it 'should return false' do
                expect(Checks::TranslateDirectionService.call(task)).to eq false
            end

            it 'should execute failure method for task' do
                expect_any_instance_of(Task).to receive(:failure)

                Checks::TranslateDirectionService.call(task)
            end
        end
    end
end

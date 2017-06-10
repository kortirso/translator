RSpec.describe CheckTranslateDirectionService do
    describe '#call' do
        context 'for valid task' do
            let!(:task) { create :task, from: 'ru' }

            it 'should return true' do
                expect(CheckTranslateDirectionService.call(task)).to eq true
            end
        end

        context 'for invalid task' do
            let(:task) { create :task, from: '11' }

            it 'should return false' do
                expect(CheckTranslateDirectionService.call(task)).to eq false
            end

            it 'should execute failure method for task' do
                expect_any_instance_of(Task).to receive(:failure)

                CheckTranslateDirectionService.call(task)
            end
        end
    end
end

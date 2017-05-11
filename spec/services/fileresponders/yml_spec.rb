RSpec.describe Fileresponders::Yml do
    describe '#initialize' do
        let!(:task) { create :task }
        let(:responder) { Fileresponders::Yml.new(task) }

        it 'should assign task to @task' do
            expect(responder.task).to eq task
        end

        it 'should assign {} to @result' do
            expect(responder.result).to eq({})
        end

        it 'should assign [] to @words_for_translate' do
            expect(responder.words_for_translate).to eq []
        end
    end
end
RSpec.describe Fileresponders::Extensions::Yml do
    describe '#initialize' do
        let!(:task) { create :task }
        let(:responder) { Fileresponders::Extensions::Yml.new(task) }

        it 'should assign task to @task' do
            expect(responder.task).to eq task
        end

        it 'should assign {} to @finish_hash' do
            expect(responder.finish_hash).to eq({})
        end

        it 'should assign [] to @words_for_translate' do
            expect(responder.words_for_translate).to eq []
        end
    end
end
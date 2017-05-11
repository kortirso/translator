RSpec.describe Fileresponders::Xml do
    describe '#initialize' do
        let!(:task) { create :task }
        let(:responder) { Fileresponders::Xml.new(task) }

        it 'should assign task to @task' do
            expect(responder.task).to eq task
        end

        it 'should assign [] to @words_for_translate' do
            expect(responder.words_for_translate).to eq []
        end

        it 'should assing value for const GUEST_LIMIT' do
            expect(responder.class::GUEST_LIMIT).to eq 50
        end

        it 'should assing value for const USER_LIMIT' do
            expect(responder.class::USER_LIMIT).to eq 100
        end
    end
end
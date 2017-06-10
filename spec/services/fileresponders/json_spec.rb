RSpec.describe Fileresponders::Json do
    describe '#initialize' do
        let!(:task) { create :task }
        let(:responder) { Fileresponders::Json.new(task) }

        it 'should assign task to @task' do
            expect(responder.task).to eq task
        end

        it 'should assign Fileloaders::Json object to @fileloader' do
            expect(responder.fileloader.class.name).to eq 'Fileloaders::Json'
        end

        it 'should assign [] to @words_for_translate' do
            expect(responder.words_for_translate).to eq []
        end
    end
end

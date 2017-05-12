RSpec.describe Fileloaders::Xml do
    describe '#initialize' do
        let!(:task) { create :task }
        let(:loader) { Fileloaders::Xml.new(task) }

        it 'should assign task to @task' do
            expect(loader.task).to eq task
        end
    end
end
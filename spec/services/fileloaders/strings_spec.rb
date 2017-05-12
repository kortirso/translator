RSpec.describe Fileloaders::Strings do
    describe '#initialize' do
        let!(:task) { create :task }
        let(:loader) { Fileloaders::Strings.new(task) }

        it 'should assign task to @task' do
            expect(loader.task).to eq task
        end
    end
end
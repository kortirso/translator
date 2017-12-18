RSpec.describe FileHandle::Upload::RailsService do
    describe '.initialize' do
        context 'if file does not exist' do
            let!(:task_without_file) { create :task }

            it 'updates task with failed status' do
                FileHandle::Upload::RailsService.new(task: task_without_file)

                expect(task_without_file.status).to eq 'failed'
                expect(task_without_file.error).to eq 101
            end
        end

        context 'if file exists' do
            let!(:task) { create :task, :with_yml }
            let(:loader) { FileHandle::Upload::RailsService.new(task: task) }

            it 'assigns task to @task' do
                expect(loader.task).to eq task
            end
        end
    end
end

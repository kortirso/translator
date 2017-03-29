RSpec.describe TaskProcessingJob, type: :job do
    let(:task) { create :task }

    it 'should execute TaskProcessingService' do
        expect(TaskProcessingService).to receive(:execute).with(task)
        TaskProcessingJob.perform_now(task)
    end
end

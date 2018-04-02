RSpec.describe TaskProcessingJob, type: :job do
  let(:task) { create :task }

  it 'executes method call of TaskProcessingService' do
    expect_any_instance_of(TaskProcessingService).to receive(:call)

    TaskProcessingJob.perform_now(task)
  end
end

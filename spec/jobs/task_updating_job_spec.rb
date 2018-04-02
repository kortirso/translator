RSpec.describe TaskUpdatingJob, type: :job do
  let!(:task) { create :task }
  let!(:position) { create :position, task: task }

  it 'executes method call of Translate::RebuildService' do
    expect_any_instance_of(Translate::RebuildService).to receive(:call)

    TaskUpdatingJob.perform_now(position.translation, task)
  end
end

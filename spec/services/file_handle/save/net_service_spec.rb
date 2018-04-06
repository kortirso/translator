RSpec.describe FileHandle::Save::NetService do
  describe '.initialize' do
    let!(:framework) { create :net_framework }
    let!(:task) { create :task, :with_resx, framework: framework }
    let(:loader) { FileHandle::Save::NetService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end
  end
end

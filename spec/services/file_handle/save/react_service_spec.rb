RSpec.describe FileHandle::Save::ReactService do
  describe '.initialize' do
    let!(:framework) { create :react_framework }
    let!(:task) { create :task, :with_json, framework: framework }
    let(:loader) { FileHandle::Save::ReactService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end
  end
end

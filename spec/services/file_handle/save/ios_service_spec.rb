RSpec.describe FileHandle::Save::IosService do
  describe '.initialize' do
    let!(:framework) { create :ios_framework }
    let!(:task) { create :task, :with_strings, framework: framework }
    let(:loader) { FileHandle::Save::IosService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end
  end
end

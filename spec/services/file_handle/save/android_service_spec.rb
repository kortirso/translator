RSpec.describe FileHandle::Save::AndroidService do
  describe '.initialize' do
    let!(:framework) { create :android_framework }
    let!(:task) { create :task, :with_xml, framework: framework }
    let(:loader) { FileHandle::Save::AndroidService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end
  end
end

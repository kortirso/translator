RSpec.describe FileHandle::Save::YiiService do
  describe '.initialize' do
    let!(:framework) { create :yii_framework }
    let!(:task) { create :task, :with_php, framework: framework }
    let(:loader) { FileHandle::Save::YiiService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end
  end
end

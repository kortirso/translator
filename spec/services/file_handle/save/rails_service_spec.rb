RSpec.describe FileHandle::Save::RailsService do
  describe '.initialize' do
    let!(:framework) { create :rails_framework }
    let!(:task) { create :task, :with_yml, framework: framework }
    let(:loader) { FileHandle::Save::RailsService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end
  end
end

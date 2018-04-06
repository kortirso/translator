RSpec.describe FileHandle::Save::LaravelService do
  describe '.initialize' do
    let!(:framework) { create :laravel_framework }
    let!(:task) { create :task, :with_json_keyed, framework: framework }
    let(:loader) { FileHandle::Save::LaravelService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end
  end
end

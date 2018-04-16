RSpec.describe Translate::RebuildService do
  let!(:task) { create :task, :with_yml, from: 'ru' }
  let(:rebuilder) { Translate::RebuildService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(rebuilder.task).to eq task
    end
  end

  describe 'methods' do
    context '.call' do
    end
  end
end

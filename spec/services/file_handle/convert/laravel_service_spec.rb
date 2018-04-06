RSpec.describe FileHandle::Convert::LaravelService do
  describe '.initialize' do
    let!(:framework) { create :laravel_framework }
    let!(:task) { create :task, :with_json_keyed, framework: framework }
    let(:loader) { FileHandle::Convert::LaravelService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end

    it 'and assigns [] to @words_for_translate' do
      expect(loader.words_for_translate).to eq []
    end

    it 'and assigns FileHandle::Fragment::LaravelService to @fragment_service' do
      expect(loader.fragment_service.is_a?(FileHandle::Fragment::LaravelService)).to eq true
    end
  end
end

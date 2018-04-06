RSpec.describe FileHandle::Convert::RailsService do
  describe '.initialize' do
    let!(:framework) { create :rails_framework }
    let!(:task) { create :task, :with_yml, framework: framework }
    let(:loader) { FileHandle::Convert::RailsService.new(task: task) }

    it 'assigns task to @task' do
      expect(loader.task).to eq task
    end

    it 'and assigns [] to @words_for_translate' do
      expect(loader.words_for_translate).to eq []
    end

    it 'and assigns FileHandle::Fragment::RailsService to @fragment_service' do
      expect(loader.fragment_service.is_a?(FileHandle::Fragment::RailsService)).to eq true
    end
  end
end

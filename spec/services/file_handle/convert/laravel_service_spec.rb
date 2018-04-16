RSpec.describe FileHandle::Convert::LaravelService do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :laravel_framework }
  let!(:task) { create :task, :with_json_keyed, framework: framework, from: 'ru' }
  let(:converter) { FileHandle::Convert::LaravelService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(converter.task).to eq task
    end

    it 'and assigns FileHandle::Fragment::LaravelService to @fragment_service' do
      expect(converter.fragment_service.is_a?(FileHandle::Fragment::LaravelService)).to eq true
    end
  end
end

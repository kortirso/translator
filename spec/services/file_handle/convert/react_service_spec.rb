RSpec.describe FileHandle::Convert::ReactService do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :react_framework }
  let!(:task) { create :task, :with_json, framework: framework, from: 'ru' }
  let(:converter) { FileHandle::Convert::ReactService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(converter.task).to eq task
    end

    it 'and assigns FileHandle::Fragment::ReactService to @fragment_service' do
      expect(converter.fragment_service.is_a?(FileHandle::Fragment::ReactService)).to eq true
    end
  end
end

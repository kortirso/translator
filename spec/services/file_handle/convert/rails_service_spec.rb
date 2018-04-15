RSpec.describe FileHandle::Convert::RailsService do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :rails_framework }
  let!(:task) { create :task, :with_yml, framework: framework, from: 'ru' }
  let(:converter) { FileHandle::Convert::RailsService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(converter.task).to eq task
    end

    it 'and assigns [] to @words_for_translate' do
      expect(converter.words_for_translate).to eq []
    end

    it 'and assigns FileHandle::Fragment::RailsService to @fragment_service' do
      expect(converter.fragment_service.is_a?(FileHandle::Fragment::RailsService)).to eq true
    end
  end

  describe 'methods' do
    context 'jsonable' do
      context '.convert' do
        let(:hash_for_translate) { { hello: 'Hello', index: { hi: 'Hi', bye: 'Bye', night: 'Good. Night' } } }
        before { converter.convert(hash_for_translate) }

        it 'creates temporary hash' do
          expect(converter.temporary.is_a?(Hash)).to eq true
        end
      end
    end
  end
end

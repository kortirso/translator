RSpec.describe FileHandle::Convert::RailsService do
  let!(:framework) { create :rails_framework }
  let!(:task) { create :task, :with_yml, framework: framework }
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

        it 'collects words for translate' do
          expect(converter.words_for_translate.is_a?(Array)).to eq true
          expect(converter.words_for_translate.size).to eq 4
          expect(converter.words_for_translate[0]).to eq ['Hello']
          expect(converter.words_for_translate[1]).to eq ['Hi']
          expect(converter.words_for_translate[2]).to eq ['Bye']
          expect(converter.words_for_translate[3]).to eq %w[Good Night]
        end

        it 'and creates temporary hash' do
          expect(converter.temporary).to eq('hello' => '_##Hello##_', 'index' => { 'hi' => '_##Hi##_', 'bye' => '_##Bye##_', 'night' => '_##Good##_. _##Night##_' })
        end
      end
    end
  end
end

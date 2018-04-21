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

  describe 'methods' do
    context 'jsonable' do
      context '.convert' do
        let(:hash_for_translate) { { hello: ['one', 'two', 'three'] } }
        before { converter.convert(hash_for_translate) }

        it 'creates temporary hash' do
          expect(converter.temporary.is_a?(Hash)).to eq true
        end

        it 'and values are start with _## and end with ##_' do
          new_values = converter.temporary['hello']

          new_values.each do |value|
            expect(value.starts_with?('_##')).to eq true
            expect(value.ends_with?('##_')).to eq true
          end
        end
      end
    end
  end
end

RSpec.describe FileHandle::Convert::NetService do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :net_framework }
  let!(:task) { create :task, :with_resx, framework: framework, from: 'ru' }
  let(:converter) { FileHandle::Convert::NetService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(converter.task).to eq task
    end

    it 'and assigns FileHandle::Fragment::NetService to @fragment_service' do
      expect(converter.fragment_service.is_a?(FileHandle::Fragment::NetService)).to eq true
    end
  end

  context 'Main methods' do
    let(:loader) { FileHandle::Upload::NetService.new(task: task) }
    let(:uploaded) { loader.load }

    describe '.convert' do
      before { converter.convert(uploaded) }

      it 'saves temporary data in temporary' do
        expect(converter.temporary.is_a?(Nokogiri::XML::Document)).to eq true
      end
    end

    describe '.for_translate' do
      it 'selects data for translate' do
        result = converter.send(:for_translate, uploaded)

        expect(result.is_a?(Nokogiri::XML::NodeSet)).to eq true
        expect(result.size).to eq 1
        result.each do |element|
          expect(element.name == 'value').to eq true
        end
      end
    end
  end
end

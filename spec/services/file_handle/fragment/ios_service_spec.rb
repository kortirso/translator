RSpec.describe FileHandle::Fragment::IosService, type: :service do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :ios_framework }
  let!(:task) { create :task, :with_strings, framework: framework, from: 'ru' }
  let(:fragmenter) { FileHandle::Fragment::IosService.new(task: task) }

  describe '.create_position' do
    let(:base_value) { 'Label. Word' }
    let(:temp_value) { '_##Label##_. _##Word##_' }
    let(:phrases) { %w[Label Word] }
    let(:request) { fragmenter.send(:create_position, base_value: base_value, temp_value: temp_value, phrases: phrases) }

    it 'creates new position' do
      expect { request }.to change { Position.count }.by(1)
    end

    it 'and position has changed temp_value' do
      request

      expect(Position.last.temp_value).to_not eq '_##Label##_. _##Word##_'
    end

    it 'and creates 2 new phrases' do
      expect { request }.to change { Phrase.count }.by(2)
    end
  end

  describe '.perform_phrase' do
    context 'for sentence' do
      let(:sentence) { 'Page not found' }

      it 'returns modified sentence and array for translate' do
        answer = fragmenter.perform_phrase(sentence)

        expect(answer[:sentence]).to eq '_##Page not found##_'
        expect(answer[:blocks_for_translate]).to eq ['Page not found']
      end
    end

    context 'for sentence with formatter' do
      let(:sentence) { '%d file(s) remaining' }

      it 'returns modified sentence and array for translate without formatter' do
        answer = fragmenter.perform_phrase(sentence)

        expect(answer[:sentence]).to eq '%d _##file(s) remaining##_'
        expect(answer[:blocks_for_translate]).to eq ['file(s) remaining']
      end
    end
  end
end

RSpec.describe FileHandle::FragmentService, type: :service do
  let!(:locale) { create :locale, :ru }
  let!(:framework) { create :react_framework }
  let!(:task) { create :task, :with_json, framework: framework, from: 'ru' }
  let(:fragmenter) { FileHandle::Fragment::ReactService.new(task: task) }

  describe '.perform_sentence' do
    context 'for array' do
      let(:sentence) { ['one', 'two', 'three'] }

      it 'creates new positions' do
        expect { fragmenter.perform_sentence(sentence) }.to change(Position, :count).by(sentence.size)
      end

      it 'and creates new words' do
        expect { fragmenter.perform_sentence(sentence) }.to change(Word, :count).by(sentence.size)
      end

      it 'and creates new phrases' do
        expect { fragmenter.perform_sentence(sentence) }.to change(Phrase, :count).by(sentence.size)
      end

      it 'and returns changed array' do
        expect(fragmenter.perform_sentence(sentence)).to_not eq sentence
      end

      it 'and values are start with _## and end with ##_' do
        new_values = fragmenter.perform_sentence(sentence)

        new_values.each do |value|
          expect(value.starts_with?('_##')).to eq true
          expect(value.ends_with?('##_')).to eq true
        end
      end
    end

    context 'for string' do
      let(:sentence) { 'one' }

      it 'creates new position' do
        expect { fragmenter.perform_sentence(sentence) }.to change(Position, :count).by(1)
      end

      it 'and creates new word' do
        expect { fragmenter.perform_sentence(sentence) }.to change(Word, :count).by(1)
      end

      it 'and creates new phrase' do
        expect { fragmenter.perform_sentence(sentence) }.to change(Phrase, :count).by(1)
      end

      it 'and returns changed string' do
        expect(fragmenter.perform_sentence(sentence)).to_not eq sentence
      end

      it 'and new_value is started with _## and end with ##_' do
        new_value = fragmenter.perform_sentence(sentence)

        expect(new_value.starts_with?('_##')).to eq true
        expect(new_value.ends_with?('##_')).to eq true
      end
    end

    context 'for other types' do
      let(:sentence) { :one }

      it 'does not create new position' do
        expect { fragmenter.perform_sentence(sentence) }.to_not change(Position, :count)
      end

      it 'and does not create new word' do
        expect { fragmenter.perform_sentence(sentence) }.to_not change(Word, :count)
      end

      it 'and does not create new phrase' do
        expect { fragmenter.perform_sentence(sentence) }.to_not change(Phrase, :count)
      end

      it 'and returns unchanged value' do
        expect(fragmenter.perform_sentence(sentence)).to eq sentence
      end
    end
  end
end

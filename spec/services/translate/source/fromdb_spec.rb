RSpec.describe Translate::Source::FromDb do
  let!(:locale_en) { create :locale, :en }
  let!(:locale_ru) { create :locale, :ru }
  let!(:locale_da) { create :locale, :da }
  let!(:task) { create :task, :with_yml, from: 'ru' }
  let(:translator) { Translate::Source::FromDb.new(task: task) }

  describe '.initialize' do
    it 'should assign task to @task' do
      expect(translator.task).to eq task
    end

    it 'should assign ru locale to @locale_from' do
      expect(translator.locale_from).to eq locale_ru
    end

    it 'should assign en locale to @locale_to' do
      expect(translator.locale_to).to eq locale_en
    end
  end

  describe '.find_translation' do
    context 'there is no word for translate in DB' do
      it 'returns nil' do
        expect(translator.find_translation(word: 'Example')).to eq nil
      end
    end

    context 'there is word for translate in DB' do
      let!(:word_ru) { create :word, :ru, locale: locale_ru }
      let!(:word_en) { create :word, :en, locale: locale_en }

      context 'there are no verified translations' do
        let!(:translation_ru_en) { create :translation, base: word_ru, result: word_en }

        context 'there are no translations for locale' do
          let!(:task_da) { create :task, :with_yml, from: 'ru', to: 'da' }
          let!(:translator_da) { Translate::Source::FromDb.new(task: task_da) }

          it 'returns nil' do
            expect(translator_da.find_translation(word: word_ru.text)).to eq nil
          end
        end

        context 'there are translations for locale' do
          it 'returns text of most popular translation' do
            expect(translator.find_translation(word: word_ru.text)).to eq word_en.text
          end

          it 'creates new position between translation and task' do
            skip '1'

            expect { translator.find_translation(word: word_ru.text) }.to change(Position, :count).by(1)
          end
        end
      end

      context 'there are verified translations' do
        let!(:translation_ru_en) { create :translation, base: word_ru, result: word_en, verified: true }

        context 'there are no translations for locale' do
          let!(:task_da) { create :task, :with_yml, from: 'ru', to: 'da' }
          let!(:translator_da) { Translate::Source::FromDb.new(task: task_da) }

          it 'returns nil' do
            expect(translator_da.find_translation(word: word_ru.text)).to eq nil
          end
        end

        context 'there are translations for locale' do
          it 'returns text of most popular translation' do
            expect(translator.find_translation(word: word_ru.text)).to eq word_en.text
          end
        end
      end
    end
  end
end

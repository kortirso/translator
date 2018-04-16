RSpec.describe Translate::WordService do
  let!(:locale_en) { create :locale, :en }
  let!(:locale_ru) { create :locale, :ru }
  let!(:task) { create :task, :with_yml, from: 'ru' }
  let(:worder) { Translate::WordService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(worder.task).to eq task
    end

    it 'assigns Translate::Source::FromDb object to @db_translator' do
      expect(worder.db_translator.is_a?(Translate::Source::FromDb)).to eq true
    end

    it 'assigns Translate::Source::FromYandex object to @yandex_translator' do
      expect(worder.yandex_translator.is_a?(Translate::Source::FromYandex)).to eq true
    end

    it 'assigns [] object to @new_words' do
      expect(worder.new_words.is_a?(Array)).to eq true
    end
  end

  describe 'methods' do
    context '.translate' do
      context 'for unexsisted word in DB' do
        it 'returns word from yandex call' do
          stub_request(:post, "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{ENV['YANDEX_TRANSLATE_API_KEY']}&lang=ru-en&text=Привет")
            .to_return(status: 200, body: '{"code":200, "lang":"ru-en", "text": ["Hello"]}', headers: {})

          expect(worder.translate(word: 'Привет')).to eq 'Hello'
        end

        it 'and adds word with translation to new_words' do
          stub_request(:post, "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{ENV['YANDEX_TRANSLATE_API_KEY']}&lang=ru-en&text=Привет")
            .to_return(status: 200, body: '{"code":200, "lang":"ru-en", "text": ["Hello"]}', headers: {})

          worder.translate(word: 'Привет')

          expect(worder.new_words).to eq [{ word: 'Привет', answer: 'Hello' }]
        end
      end

      context 'for existed word in DB' do
        let!(:word_ru) { create :word, :ru, locale: locale_ru }
        let!(:word_en) { create :word, :en, locale: locale_en }
        let!(:translation_ru_en) { create :translation, base: word_ru, result: word_en }

        it 'returns word from DB call' do
          expect(worder.translate(word: word_ru.text)).to eq word_en.text
        end
      end
    end

    context '.save_new_words' do
      before { worder.new_words << { word: 'Привет', answer: 'Hello' } }

      it 'creates 2 new words' do
        expect { worder.save_new_words }.to change(Word, :count).by(2)
      end
    end
  end
end

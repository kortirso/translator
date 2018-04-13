RSpec.describe Translate::Source::FromYandex do
  let!(:task) { create :task, :with_yml, from: 'ru' }
  let(:translator) { Translate::Source::FromYandex.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(translator.task).to eq task
    end

    it 'assigns YandexTranslator object to @yandex_translator' do
      expect(translator.yandex_translator.is_a?(Yandex::Translator)).to eq true
    end
  end

  describe 'methods' do
    context '.find_translate' do
      context 'for simple task' do
        it 'returns word' do
          stub_request(:post, "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{ENV['YANDEX_TRANSLATE_API_KEY']}&lang=ru-en&text=Привет")
            .to_return(status: 200, body: '{"code":200, "lang":"ru-en", "text": ["Hello"]}', headers: {})

          expect(translator.find_translate(word: 'Привет')).to eq 'Hello'
        end
      end
    end

    context '.request' do
      it 'returns nil for invalid data' do
        stub_request(:post, "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{ENV['YANDEX_TRANSLATE_API_KEY']}&lang=enn-ru&text=Hello")
          .to_return(status: 200, body: '{"error":"Bad Request"}', headers: {})

        expect(translator.send(:request, 'enn', 'ru', 'Hello')).to eq nil
      end

      it 'returns word for valid data' do
        stub_request(:post, "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{ENV['YANDEX_TRANSLATE_API_KEY']}&lang=en-ru&text=Hello")
          .to_return(status: 200, body: '{"code":200, "lang":"en-ru", "text": ["Привет"]}', headers: {})

        expect(translator.send(:request, 'en', 'ru', 'Hello')).to eq 'Привет'
      end
    end
  end
end

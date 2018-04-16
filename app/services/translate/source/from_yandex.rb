require 'yandex'

module Translate
  module Source
    # Request to Yandex for getting translation
    class FromYandex
      attr_reader :task, :yandex_translator

      def initialize(args = {})
        @task = args[:task]
        @yandex_translator = Yandex::Translator.new(api_key: ENV['YANDEX_TRANSLATE_API_KEY'])
      end

      def find_translation(args)
        if task.double?
          en_word = request(task.from, 'en', args[:word])
          en_word.present? ? request('en', task.to, en_word) : nil
        else
          request(task.from, task.to, args[:word])
        end
      end

      private def request(from, to, word)
        response = yandex_translator.translate(text: word, from: from, to: to)
        return nil unless response['text'].is_a?(Array)
        response['text'][0]
      end
    end
  end
end

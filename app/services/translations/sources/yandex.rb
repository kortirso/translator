require 'yandex'

module Translations
    module Sources
        # Request to Yandex for getting translation
        class Yandex
            def self.find_translate(params)
                if params[:task].double?
                    en_word = request(params[:task].from, 'en', params[:word])
                    en_word.present? ? request('en', params[:task].to, en_word) : nil
                else
                    request(params[:task].from, params[:task].to, params[:word])
                end
            end

            def self.request(from, to, word)
                response = Yandex::Translator.new('api_key').translate(text: word, from: from, to: to)
                return nil unless response.is_a?(Array)
                response[0]
            end
        end
    end
end

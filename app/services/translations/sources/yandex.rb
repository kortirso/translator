require 'net/http'

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
                uri = URI("https://translate.yandex.net/api/v1.5/tr.json/translate?lang=#{from}-#{to}&key=#{ENV['YANDEX_TRANSLATE_API_KEY']}")
                req = Net::HTTP::Post.new(uri)
                req.set_form_data(text: word)
                res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
                return nil unless res.code == '200'
                JSON.parse(res.body)['text'][0]
            end
        end
    end
end

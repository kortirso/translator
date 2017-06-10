require 'net/http'

module Translations
    module Sources
        # Request to Yandex for getting translation
        class Yandex
            def self.find_translate(params)
                uri = URI("https://translate.yandex.net/api/v1.5/tr.json/translate?lang=#{params[:task].from}-#{params[:task].to}&key=#{ENV['YANDEX_TRANSLATE_API_KEY']}")
                req = Net::HTTP::Post.new(uri)
                req.set_form_data(text: params[:word])
                res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
                return false unless res.code == '200'
                JSON.parse(res.body)['text'][0]
            end
        end
    end
end

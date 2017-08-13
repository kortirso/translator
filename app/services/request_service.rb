require 'net/http'

# Represents service for requests
class RequestService
    attr_reader :api_key, :request, :uri

    def initialize(args)
        @api_key = ENV['YANDEX_TRANSLATE_API_KEY']
        @request = args[:request]
        @uri = select_uri(args)
    end

    def call(word = nil)
        case request
            when :get_langs then request_get_langs
            when :translate then request_translate(word)
        end
    end

    private

    def select_uri(args)
        case request
            when :get_langs then URI("https://translate.yandex.net/api/v1.5/tr.json/getLangs?ui=#{args[:from]}&key=#{api_key}")
            when :translate then URI("https://translate.yandex.net/api/v1.5/tr.json/translate?lang=#{args[:from]}-#{args[:to]}&key=#{api_key}")
        end
    end

    def request_get_langs
        req = Net::HTTP::Get.new(uri)
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
        return nil unless res.code == '200'
        JSON.parse(res.body)
    end

    def request_translate(word)
        req = Net::HTTP::Post.new(uri)
        req.set_form_data(text: word)
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
        return nil unless res.code == '200'
        JSON.parse(res.body)['text'][0]
    end
end

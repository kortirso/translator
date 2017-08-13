require 'net/http'

# Represents service for requests
class RequestService
    attr_reader :uri

    def initialize(args)
        @api_key = ENV['YANDEX_TRANSLATE_API_KEY']
        @uri = select_uri(args)
    end

    def request(word = nil)
        case args[:request]
            when :get_langs then get_request
            when :translate then post_request(word)
        end
    end

    private

    def select_uri(args)
        case args[:request]
            when :get_langs then URI("https://translate.yandex.net/api/v1.5/tr.json/getLangs?ui=#{args[:from]}&key=#{api_key}")
            when :translate then URI("https://translate.yandex.net/api/v1.5/tr.json/translate?lang=#{args[:from]}-#{args[:to]}&key=#{api_key}")
        end
    end

    def get_request
        req = Net::HTTP::Get.new(uri)
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
        return nil unless res.code == '200'
        JSON.parse(res.body)['dirs']
    end

    def post_request(word)
        req = Net::HTTP::Post.new(uri)
        req.set_form_data(text: word)
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
        return nil unless res.code == '200'
        JSON.parse(res.body)['text'][0]
    end
end
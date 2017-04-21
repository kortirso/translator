require 'net/http'

module Translations
    class LangExistService
        def self.call(task)
            uri = URI("https://translate.yandex.net/api/v1.5/tr.json/getLangs?ui=#{task.from}&key=#{ENV['YANDEX_TRANSLATE_API_KEY']}")
            req = Net::HTTP::Get.new(uri)
            res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
            return false unless res.code == '200'
            JSON.parse(res.body)['dirs'].include? "#{task.from}-#{task.to}"
        end
    end
end
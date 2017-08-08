require 'net/http'

module Checks
    # Check existness of translation direction at Yandex
    class TranslateDirectionService
        def self.call(task)
            return true if request(task.from, task.to)
            return task.double_translating if request(task.from, 'en') && request('en', task.to)
            task.failure(201)
        end

        def self.request(from, to)
            uri = URI("https://translate.yandex.net/api/v1.5/tr.json/getLangs?ui=#{from}&key=#{ENV['YANDEX_TRANSLATE_API_KEY']}")
            req = Net::HTTP::Get.new(uri)
            res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
            return false unless res.code == '200'
            return false unless JSON.parse(res.body)['dirs'].include? "#{from}-#{to}"
            true
        end
    end
end

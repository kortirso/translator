require 'yandex'

module Checks
    # Check existness of translation direction at Yandex
    class TranslateDirectionService
        def self.call(task)
            return task.failure(203) unless Locale.code_list.include?(task.from)
            return true if request(task.from, task.to)
            return task.double_translating if request(task.from, 'en') && request('en', task.to)
            task.failure(201)
        end

        def self.request(from, to)
            response = Yandex::Translator.new(ENV['YANDEX_TRANSLATE_API_KEY']).langs
            return false unless response.is_a?(Array)
            return false unless response.include? "#{from}-#{to}"
            true
        end
    end
end

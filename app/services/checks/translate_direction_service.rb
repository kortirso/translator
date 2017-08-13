module Checks
    # Check existness of translation direction at Yandex
    class TranslateDirectionService
        def self.call(task)
            return true if request(task.from, task.to)
            return task.double_translating if request(task.from, 'en') && request('en', task.to)
            task.failure(201)
        end

        def self.request(from, to)
            answer = RequestService.new(request: :get_langs, from: from).call
            return false if answer.nil?
            return false unless answer['dirs'].include? "#{from}-#{to}"
            true
        end
    end
end

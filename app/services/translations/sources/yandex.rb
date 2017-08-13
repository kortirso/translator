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
                RequestService.new(request: :translate, from: from, to: to).call(word)
            end
        end
    end
end

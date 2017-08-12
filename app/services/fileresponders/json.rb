module Fileresponders
    # Fileresponder for *.json
    class Json
        include Fileresponders::Base

        def check_permissions
            return task.failure(301) if task.user.nil? && base_data.size > GUEST_LIMIT
            return task.failure(302) if task.user.present? && base_data.size > USER_LIMIT
            true
        end

        private

        def strings_for_translate(new_data = {})
            base_data.each do |key, value|
                checked = Checks::SentenceService.call(value, :json)
                words_for_translate.push checked[:blocks_for_translate]
                new_data[key] = checked[:sentence]
            end
            @result = new_data
        end
    end
end

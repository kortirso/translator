module Fileresponders
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
                words_for_translate.push value
                new_data[key] = "_###{value}##_"
            end
            @result = new_data
        end
    end
end

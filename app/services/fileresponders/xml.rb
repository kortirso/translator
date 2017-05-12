module Fileresponders
    class Xml
        include Fileresponders::Base

        def check_permissions
            return task.failure(301) if task.user.nil? && base_data.size > GUEST_LIMIT
            return task.failure(302) if task.user.present? && base_data.size > USER_LIMIT
            true
        end

        private

        def strings_for_translate
            base_data.each do |value|
                words_for_translate.push value.children.to_s
                value.children = "_###{value.children.to_s}##_"
            end
            @result = base_data
        end
    end
end
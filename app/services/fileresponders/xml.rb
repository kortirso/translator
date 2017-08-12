module Fileresponders
    # Fileresponder for *.xml
    class Xml
        include Fileresponders::Base

        def check_permissions
            for_translate = base_data.xpath('//resources/string')
            return task.failure(301) if task.user.nil? && for_translate.size > GUEST_LIMIT
            return task.failure(302) if task.user.present? && for_translate.size > USER_LIMIT
            true
        end

        private

        def strings_for_translate
            base_data.xpath('//resources/string').each do |value|
                words_for_translate.push value.children.to_s
                value.children = "_###{value.children}##_"
            end
            @result = base_data
        end
    end
end

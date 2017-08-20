module Fileresponders
    # Fileresponder for *.xml
    class Xml
        include Fileresponders::Base

        def check_permissions
            for_translate = base_data.xpath('//resources/string') + base_data.xpath('//resources/string-array/item')
            return task.failure(301) if task.user.nil? && for_translate.size > GUEST_LIMIT
            return task.failure(302) if task.user.present? && for_translate.size > USER_LIMIT
            true
        end

        private

        def strings_for_translate
            for_translate = (base_data.xpath('//resources/string') + base_data.xpath('//resources/string-array/item')).select { |tag| tag.attributes['translatable'].nil? || tag.attributes['translatable'].value != 'false' }
            for_translate.each do |value|
                checked = sentence_service.call(value.children.to_s)
                words_for_translate.push checked[:blocks_for_translate]
                value.children = checked[:sentence]
            end
            @result = base_data
        rescue
            raise AuthFailure, '402'
        end
    end
end

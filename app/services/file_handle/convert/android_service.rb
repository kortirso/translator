require 'nokogiri'

module FileHandle
  module Convert
    # FileConverter for *.xml from Android
    class AndroidService < FileHandle::ConvertService
      def convert(data)
        translatable(data).each do |tag|
          tag.children = fragment_service.perform_sentence(tag.children.to_s)
        end
        @temporary = data
      end

      private def translatable(data)
        for_translate(data).select { |tag| tag.attributes['translatable'].nil? || tag.attributes['translatable'].value != 'false' }
      end

      private def for_translate(data)
        data.xpath('//resources/string') + data.xpath('//resources/string-array/item') + data.xpath('//resources/plurals/item')
      end
    end
  end
end

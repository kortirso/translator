require 'nokogiri'

module FileHandle
  module Convert
    # FileUploader for *.xml from Android
    class AndroidService < FileHandle::ConvertService
      attr_reader :temporary

      def convert(data)
        for_translate = (data.xpath('//resources/string') + data.xpath('//resources/string-array/item')).select { |tag| tag.attributes['translatable'].nil? || tag.attributes['translatable'].value != 'false' }
        for_translate.each do |value|
          checked = sentence_service.call(value.children.to_s)
          words_for_translate.push checked[:blocks_for_translate]
          value.children = checked[:sentence]
        end
        @temporary = data
      end
    end
  end
end

require 'nokogiri'

module FileHandle
  module Convert
    # FileUploader for *.resx from .NET
    class NetService < FileHandle::ConvertService
      attr_reader :temporary

      def convert(data)
        data.xpath('//data/value').each do |value|
          checked = sentence_service.call(value.children.to_s)
          words_for_translate.push checked[:blocks_for_translate]
          value.children = checked[:sentence]
        end
        @temporary = data
      end
    end
  end
end

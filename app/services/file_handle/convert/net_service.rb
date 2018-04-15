require 'nokogiri'

module FileHandle
  module Convert
    # FileUploader for *.resx from .NET
    class NetService < FileHandle::ConvertService
      def convert(data)
        for_translate(data).each do |value|
          # checked = fragment_service.perform_sentence(value.children.to_s)
          # words_for_translate << checked[:blocks_for_translate]
          value.children = fragment_service.perform_sentence(value.children.to_s)
        end
        @temporary = data
      end

      private def for_translate(data)
        data.xpath('//data/value')
      end
    end
  end
end

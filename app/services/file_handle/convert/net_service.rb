require 'nokogiri'

module FileHandle
  module Convert
    # FileConverter for *.resx from .NET
    class NetService < FileHandle::ConvertService
      def convert(data)
        for_translate(data).each do |value|
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

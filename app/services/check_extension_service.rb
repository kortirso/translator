class CheckExtensionService
    def self.call(extension)
        case extension
            when 'resx' then 'xml'
            else extension
        end
    end
end
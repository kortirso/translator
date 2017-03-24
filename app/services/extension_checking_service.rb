class ExtensionCheckingService
    def self.check_extension(extension)
        return case extension
            when 'resx' then 'xml'
            else extension
        end
    end
end
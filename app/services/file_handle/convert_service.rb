module FileHandle
    # Base class for converting files
    class ConvertService
        class AuthFailure < StandardError; end

        attr_reader :words_for_translate, :sentence_service

        def initialize(args = {})
            @words_for_translate = []
            @sentence_service = Checks::SentenceService.new(self.class.name.demodulize.to_sym)
            post_initialize(args)
        end

        # subclasses may override
        private def post_initialize(_args)
            nil
        end
    end
end

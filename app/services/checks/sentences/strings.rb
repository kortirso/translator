module Checks
    module Sentences
        # Rebuild sentence for translation from Strings
        class Strings
            include Checks::Sentences::Base

            def initialize; end

            def call(sentence)
                {
                    sentence: "_###{sentence}##_",
                    blocks_for_translate: [sentence]
                }
            end
        end
    end
end

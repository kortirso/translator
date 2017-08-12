module Checks
    module Sentences
        # Rebuild sentence for translation from Json
        class Json
            def self.call(sentence)
                {
                    sentence: "_###{sentence}##_",
                    blocks_for_translate: [sentence]
                }
            end
        end
    end
end

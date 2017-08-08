module Checks
    # Split sentences, remove untranslated things
    class SentenceService
        def self.call(value)
            @blocks = []
            rebuilded_sentence = value.split('.').collect { |sentence| checks(sentence) }.join('.')
            {
                sentence: rebuilded_sentence,
                blocks_for_translate: @blocks
            }
        end

        def self.checks(sentence)
            @blocks.push sentence
            "_###{sentence}##_"
        end
    end
end

module Checks
    # Split sentences, remove untranslated things
    class SentenceService
        def self.call(value)
            @blocks = []
            sentences = sentence_splitter(value)
            rebuilded_sentence = sentences.collect { |sentence| checks(sentence) }.join
            {
                sentence: rebuilded_sentence,
                blocks_for_translate: @blocks
            }
        end

        def self.sentence_splitter(value)
            sentences = value.split('.')
            sentences[-1] += '.' if value[-1] == '.'
            (0..(sentences.size - 2)).each.with_index do |index|
                sentences[index] += '.'
            end
            sentences
        end

        def self.checks(sentence)
            splitted_sentence = sentence.split(/[%][{](\w*)[}]/)
            variables = sentence.scan(/[%][{](\w*)[}]/)

            splitted_sentence.map! do |elem|
                if variables.include?([elem])
                    "%{#{elem}}"
                elsif elem == ''
                    elem
                else
                    @blocks.push elem
                    "_###{elem}##_"
                end
            end
            splitted_sentence.join
        end
    end
end

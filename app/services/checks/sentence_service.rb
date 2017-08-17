module Checks
    # Split sentences, remove untranslated things
    class SentenceService
        def self.call(value, extension, blocks = [], rebuilded_sentence = [])
            if value.is_a?(String)
                sentence_splitter(value).each do |sentence|
                    check = checks(sentence, extension)
                    rebuilded_sentence.push check[:sentence]
                    blocks += check[:blocks_for_translate]
                end
                rebuilded_sentence = rebuilded_sentence.join('.')
                rebuilded_sentence += '.' if value[-1] == '.'
            else
                rebuilded_sentence = value
            end
            {
                sentence: rebuilded_sentence,
                blocks_for_translate: blocks
            }
        end

        def self.sentence_splitter(value)
            value.split('.')
        end

        def self.checks(sentence, extension)
            "Checks::Sentences::#{extension.capitalize}".constantize.call(sentence)
        end
    end
end

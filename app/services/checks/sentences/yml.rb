module Checks
    module Sentences
        # Rebuild sentence for translation from Yml
        class Yml
            def self.call(sentence)
                remove_variables(sentence)
            end

            def self.remove_variables(sentence, blocks = [])
                splitted_sentence = sentence.split(/[%][{](\w*)[}]/)
                variables = sentence.scan(/[%][{](\w*)[}]/)

                splitted_sentence.map! do |elem|
                    if variables.include?([elem])
                        "%{#{elem}}"
                    elsif elem == ''
                        elem
                    else
                        blocks.push elem
                        "_###{elem}##_"
                    end
                end

                {
                    sentence: splitted_sentence.join,
                    blocks_for_translate: blocks
                }
            end
        end
    end
end

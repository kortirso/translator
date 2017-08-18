module Checks
    module Sentences
        # Rebuild sentence for translation from Yml
        class Yml
            REGEXP_TAGS = /<.+?>/
            REGEXP_VARIABLES = /%{\w+?}/
            REGEXP_START_SPACES = /^[\s,:;]*/
            REGEXP_TRAIL_SPACES = /[\s,:;]*$/

            def initialize; end

            def call(sentence)
                # remove tags
                splitted_sentence = sentence.split(REGEXP_TAGS)

                # remove variables
                splitted_sentence.map! { |elem| elem.split(REGEXP_VARIABLES) }
                splitted_sentence = splitted_sentence.flatten

                # remove first and last symbols
                splitted_sentence.map! do |elem|
                    elem.empty? ? nil : elem.gsub(REGEXP_START_SPACES, '').gsub(REGEXP_TRAIL_SPACES, '')
                end
                blocks = splitted_sentence.compact

                # modifying sentence for translate variables
                blocks.each { |elem| sentence.gsub!(elem, "_###{elem}##_") }

                # returns sentence and blocks for translate
                {
                    sentence: sentence,
                    blocks_for_translate: blocks
                }
            end
        end
    end
end

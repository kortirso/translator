module Checks
  module Sentences
    # Rebuild sentence for translation from Strings
    class Strings
      include Checks::Sentences::Base

      def initialize; end

      def call(sentence)
        # remove formats
        splitted_sentence = sentence.split(REGEXP_FORMATS)

        # remove first and last symbols
        splitted_sentence.map! do |elem|
          if elem.empty?
            nil
          else
            middle_var = elem.gsub(REGEXP_START_SPACES, '').gsub(REGEXP_TRAIL_SPACES, '')
            middle_var.empty? ? nil : middle_var
          end
        end
        blocks = splitted_sentence.compact

        # modifying sentence for translate variables
        blocks.each { |elem| sentence.gsub!(elem, "_###{elem}##_") }

        {
          sentence: sentence,
          blocks_for_translate: blocks
        }
      end
    end
  end
end

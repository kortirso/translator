module FileHandle
  module Fragment
    # Rebuild sentence for translation from Android
    class AndroidService < FileHandle::FragmentService
      def perform_phrase(phrase)
        # remove variables
        splitted_sentence = phrase.split(REGEXP_XML_VARIABLES)

        # remove special characters
        splitted_sentence.map! do |elem|
          elem.empty? ? nil : elem.split(REGEXP_SPECIAL)
        end
        splitted_sentence = splitted_sentence.flatten.compact

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

        # modifying phrase for translate variables
        blocks.each { |elem| phrase.gsub!(elem, "_###{elem}##_") }

        # returns sentence and blocks for translate
        {
          sentence: phrase,
          blocks_for_translate: blocks
        }
      end

      private def sentence_splitted_by_dot(value)
        # replace dots in variables
        value.scan(REGEXP_XML_VARIABLES).each do |tag|
          value.gsub!(tag, tag.gsub('.', '_##_'))
        end

        # split value for sentences and put dots in sentence
        value.split('.').map! { |sent| sent.gsub('_##_', '.') }
      end
    end
  end
end

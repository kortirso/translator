module FileHandle
  module Fragment
    # Rebuild sentence for translation from IOS
    class IosService < FileHandle::FragmentService
      include FileHandle::Fragment::Base

      def perform_phrase(phrase)
        # remove formats
        splitted_sentence = phrase.split(REGEXP_FORMATS)

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

        {
          sentence: phrase,
          blocks_for_translate: blocks
        }
      end

      private def sentence_splitted_by_dot(value)
        value.split('.')
      end
    end
  end
end

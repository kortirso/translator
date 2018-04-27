module FileHandle
  module Fragment
    # Rebuild sentence for translation from React
    class ReactService < FileHandle::FragmentService
      def perform_phrase(phrase)
        {
          sentence: "_###{phrase}##_",
          blocks_for_translate: [phrase]
        }
      end

      private def sentence_splitted_by_dot(value)
        value.split('.')
      end
    end
  end
end

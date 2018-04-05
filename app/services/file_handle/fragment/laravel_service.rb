module FileHandle
  module Fragment
    # Rebuild sentence for translation from Laravel
    class LaravelService < FileHandle::FragmentService
      include FileHandle::Fragment::Base

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

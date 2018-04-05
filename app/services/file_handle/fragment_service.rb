module FileHandle
  # Split sentences, remove untranslated things
  class FragmentService
    def perform_sentence(value, blocks = [], rebuilded_sentences = [])
      if value.is_a?(String)
        sentence_splitted_by_dot(value).each do |phrase|
          check = perform_phrase(phrase)
          rebuilded_sentences << check[:sentence]
          blocks += check[:blocks_for_translate]
        end
        rebuilded_sentences = rebuilded_sentences.join('.')
        rebuilded_sentences += '.' if value[-1] == '.'
      else
        rebuilded_sentences = value
      end
      {
        sentence: rebuilded_sentences,
        blocks_for_translate: blocks
      }
    end
  end
end

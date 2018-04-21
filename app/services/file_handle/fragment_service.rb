module FileHandle
  # Split sentences, remove untranslated things
  class FragmentService
    attr_reader :task, :locale_from

    def initialize(args = {})
      @task = args[:task]
      @locale_from = Locale.find_by(code: task.from)
    end

    def perform_sentence(value, blocks = [], rebuilded_sentences = [])
      if value.is_a?(String)
        sentence_splitted_by_dot(value).each do |phrase|
          check = perform_phrase(phrase)
          rebuilded_sentences << check[:sentence]
          blocks += check[:blocks_for_translate]
        end
        rebuilded_sentences = rebuilded_sentences.join('.')
        rebuilded_sentences += '.' if value[-1] == '.'
        create_position(base_value: value, temp_value: rebuilded_sentences, phrases: blocks)
      elsif value.is_a?(Array)
        value.map { |element| perform_sentence(element) }
      else
        value
      end
    end

    private def create_position(args = {})
      temp_value = args[:temp_value]
      position = task.positions.create(base_value: args[:base_value], temp_value: temp_value)
      args[:phrases].each do |phrase|
        word = Word.create_or_find_by(text: phrase, locale: locale_from)
        phrase_new = Phrase.create(word: word, position: position, current_value: phrase)
        temp_value["_###{phrase}##_"] = "_###{phrase_new.id}##_"
      end
      position.update(temp_value: temp_value)
      "_###{position.id}##_"
    end
  end
end

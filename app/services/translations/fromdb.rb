module Translations
    class Fromdb
        attr_reader :tr_from, :tr_to, :words

        def initialize(params)
            @tr_from = params[:task].from
            @tr_to = params[:task].to
            @words = ActiveModel::Serializer::CollectionSerializer.new(Locale.find_by(code: tr_from).words, each_serializer: WordSerializer).as_json
        end

        def find_translate(base_word)
            word = words.select { |w| w[:text] == base_word }
            #word = Word.find_by(locale: tr_from, text: base_word)
            return false if word.empty?
            #return nil unless word

            # todo: add additional selecting from translations
            word_id = word[0][:id]
            word_translations = Word.find(word_id).select_translations(tr_to)
            return false if word_translations.empty?

            Position.create translation: word_translations.first, task: params[:task]
            word_translations.first.text
            #word.select_translations(tr_to).first.text
        end
    end
end

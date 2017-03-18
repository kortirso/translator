module Translations
    class Fromdb
        attr_reader :tr_from, :tr_to, :words

        def initialize(params)
            @tr_from = params[:from]
            @tr_to = params[:to]
            @words = ActiveModel::Serializer::CollectionSerializer.new(Word.where(locale: tr_from), each_serializer: WordSerializer).as_json
        end

        def find_translate(base_word)
            word = words.select { |w| w[:text] == base_word }
            return false if word.empty?

            # todo: add additional selecting from translations
            word_id = word[0][:id]
            word_translations = Word.find(word_id).select_translations(tr_to)
            word_translations.first.text
        end
    end
end
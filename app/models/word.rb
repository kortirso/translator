class Word < ApplicationRecord
    belongs_to :locale

    has_many :translations, foreign_key: :base_id, dependent: :destroy
    has_many :result_words, through: :translations, source: :result

    validates :text, :locale_id, presence: true

    scope :text_begins_with, -> (str) { where('text like ?', "#{str}%").order(text: :asc) }

    def select_translations(locale)
        transform_values_to_count(select_result_words(locale))
    end

    private

    def select_result_words(locale)
        result_words.where(locale: locale).group_by(&:text)
    end

    def transform_values_to_count(hash)
        hash.each { |key, value| hash[key] = value.count }.sort_by { |key, value| value }.reverse.to_h
    end
end

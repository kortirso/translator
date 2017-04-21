class Word < ApplicationRecord
    belongs_to :locale

    has_many :translations, foreign_key: :base_id, dependent: :destroy
    has_many :result_words, through: :translations, source: :result

    has_many :reverse_translations, foreign_key: :result_id, class_name: 'Translation', dependent: :destroy
    has_many :base_words, through: :reverse_translations, source: :base

    validates :text, :locale_id, presence: true

    def select_translations(locale_code)
        locale = Locale.find_by(code: locale_code)
        result_words.where(locale: locale) + base_words.where(locale: locale)
    end
end

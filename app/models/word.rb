class Word < ApplicationRecord
    has_many :translations, foreign_key: :base_id, dependent: :destroy
    has_many :result_words, through: :translations, source: :result

    has_many :reverse_translations, foreign_key: :result_id, class_name: 'Translation', dependent: :destroy
    has_many :base_words, through: :reverse_translations, source: :base

    validates :text, :locale, presence: true
end

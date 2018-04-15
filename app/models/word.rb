# Represents words for some locale
class Word < ApplicationRecord
  belongs_to :locale

  has_many :phrases

  validates :text, :locale, presence: true

  scope :text_begins_with, ->(str) { where('text like ?', "#{str}%").order(text: :asc) }

  # returns sorted hash with translated text as keys and count of using these translations
  def select_translations(args = {})
    hash = grouped_translated_text(args[:locale])
    hash.each { |key, value| hash[key] = value.count }.sort_by { |_key, value| value }.reverse.to_h
  end

  # returns array of words
  def translated_text(args = {})
    objects = args[:locale].nil? ? translations : for_language(args[:locale])
    objects.collect(&:text)
  end

  # returns hash with translated text as keys and array of WORD objects as values
  private def grouped_translated_text(locale)
    objects = locale.nil? ? translations : for_language(locale)
    objects.group_by(&:text)
  end

  # select WORD objects for specific locale
  def for_language(locale)
    translations.select { |word| word.locale == locale }
  end

  # returns all WORD objects for specific word through translations
  private def translations
    interpretations.collect { |interpretation| interpretation.translation(id) }
  end

  # returns all TRANSLATE objects for specific word
  private def interpretations
    Translation.eager_load(:base, :result).where('base_id = ? OR result_id = ?', id, id)
  end
end

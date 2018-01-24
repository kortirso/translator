# Represents available locales for translations
class Locale < ApplicationRecord
  has_many :words, dependent: :destroy

  validates :code, :country_code, uniqueness: true, presence: true

  def self.list
    all.collect { |loc| [loc.names[I18n.locale.to_s], loc.code] }.sort_by { |loc| loc[0] }
  end

  def self.code_list
    all.pluck(:code)
  end
end

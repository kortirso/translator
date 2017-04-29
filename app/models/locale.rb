class Locale < ApplicationRecord
    has_many :words, dependent: :destroy

    def self.get_list
        all.collect { |loc| [loc.names[I18n.locale.to_s], loc.code] }.sort_by { |loc| loc[0] }
    end
end

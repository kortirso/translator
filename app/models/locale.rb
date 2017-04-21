class Locale < ApplicationRecord
    has_many :words, dependent: :destroy
end

# Represents separate phrases without special symbols from sentences for translation
class Phrase < ApplicationRecord
  belongs_to :position
  belongs_to :word

  validates :position, :word, presence: true
end

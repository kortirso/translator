# Represents links between task and its translations
# base_value - base string from source file
# temp_value - value with substrings with phrases ids
# phrases_value - value with strings from phrases
# translator_value - string presented by real translator
# current_value - current string for result file
class Position < ApplicationRecord
  belongs_to :task

  has_many :phrases, dependent: :destroy

  validates :task, :base_value, :temp_value, presence: true

  def update_phrases_value

  end
end

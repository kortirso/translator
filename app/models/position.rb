# Represents links between task and its translations
class Position < ApplicationRecord
  belongs_to :task

  has_many :phrases, dependent: :destroy

  validates :task, :base_value, :temp_value, presence: true
end

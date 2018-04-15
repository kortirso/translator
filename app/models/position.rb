# Represents links between task and its translations
class Position < ApplicationRecord
  belongs_to :task

  has_many :phrases, dependent: :destroy

  validates :task, presence: true
end

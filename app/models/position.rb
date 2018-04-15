# Represents links between task and its translations
class Position < ApplicationRecord
  belongs_to :task

  validates :task_id, presence: true
end

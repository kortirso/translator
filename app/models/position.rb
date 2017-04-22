class Position < ApplicationRecord
    belongs_to :task
    belongs_to :translation

    validates :task_id, :translation_id, presence: true
end

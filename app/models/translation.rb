class Translation < ApplicationRecord
    belongs_to :base, class_name: 'Word'
    belongs_to :result, class_name: 'Word'

    has_many :positions, dependent: :destroy
    has_many :tasks, through: :positions

    validates :base_id, :result_id, presence: true
end

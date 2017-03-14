class Translation < ApplicationRecord
    belongs_to :base, class_name: 'Word'
    belongs_to :result, class_name: 'Word'

    validates :base_id, :result_id, presence: true
end

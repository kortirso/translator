class Framework < ApplicationRecord
    validates :name, :extension, presence: true
end

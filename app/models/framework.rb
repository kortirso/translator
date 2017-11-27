# Represents frameworks with their extensions available for translation
class Framework < ApplicationRecord
    validates :name, :extension, presence: true
end

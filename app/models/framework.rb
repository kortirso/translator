# Represents frameworks with their extensions available for translation
class Framework < ApplicationRecord
    has_many :tasks

    validates :name, :extension, presence: true
end

# Represents user request for translator role
class Request < ApplicationRecord
    belongs_to :user

    validates :body, presence: true, length: { minimum: 1 }
end

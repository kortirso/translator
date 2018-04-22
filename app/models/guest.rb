# Represents guest users, reason - store their tasks with session
class Guest < ApplicationRecord
  belongs_to :user, optional: true

  has_many :tasks, as: :personable, dependent: :destroy
end

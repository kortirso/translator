# Represents guest users, reason - store their tasks with session
class Guest < ApplicationRecord
  include Personable

  belongs_to :user, optional: true
end

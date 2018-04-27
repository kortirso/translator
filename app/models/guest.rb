# Represents guest users, reason - store their tasks with session
class Guest < ApplicationRecord
  include Personable

  belongs_to :user, optional: true

  def attach_to_user(user)
    update(user: user)
    tasks.update_all(personable_id: user.id, personable_type: 'User')
  end
end

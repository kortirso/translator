# Represents link between 2 words
class Translation < ApplicationRecord
  belongs_to :base, class_name: 'Word'
  belongs_to :result, class_name: 'Word'

  validates :base, :result, presence: true

  scope :verifieded, -> { where(verified: true) }

  def translation(identifier)
    return result if base_id == identifier
    base
  end
end

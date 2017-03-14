class Task < ApplicationRecord
    validates :uid, :status, presence: true
    validates :status, inclusion: { in: %w(active done) }
end

require 'securerandom'

# Represents user object
class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    has_many :tasks, dependent: :destroy
    has_many :requests, dependent: :destroy

    validates :username, presence: true, uniqueness: true, length: { in: 1..20 }
    validates :role, presence: true, inclusion: { in: %w[user translator admin] }

    def update_token
        update(access_token: SecureRandom.hex(32))
    end

    def admin?
        role == 'admin'
    end

    def translator?
        role == 'translator'
    end

    def editor?
        admin? || translator?
    end
end

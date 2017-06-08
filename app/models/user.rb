require 'securerandom'

class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    has_many :tasks, dependent: :destroy
    has_many :requests, dependent: :destroy

    validates :username, presence: true, uniqueness: true, length: { in: 1..20 }
    validates :role, presence: true, inclusion: { in: %w(user subscriber translator admin) }

    def update_token
        self.update(access_token: SecureRandom.hex(32))
    end

    def admin?
        role == 'admin'
    end

    def translator?
        role == 'translator'
    end

    def subscriber?
        role == 'subscriber'
    end

    def editor?
        admin? || translator?
    end
end

require 'securerandom'

class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    has_many :tasks, dependent: :destroy

    validates :username, presence: true, uniqueness: true, length: { in: 1..20 }

    def update_token
        self.update(access_token: SecureRandom.hex(32))
    end
end

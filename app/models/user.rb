# Represents user object
class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

    has_many :tasks, dependent: :destroy
    has_many :requests, dependent: :destroy
    has_many :identities, dependent: :destroy

    validates :username, presence: true, uniqueness: true, length: { in: 1..20 }
    validates :role, presence: true, inclusion: { in: %w[user translator admin] }

    def self.find_for_oauth(auth)
        identity = Identity.find_for_oauth(auth)
        return identity.user if identity.present?
        user = User.find_by(email: auth.info[:email])
        user = User.create(email: auth.info[:email], password: Devise.friendly_token[0,20]) if user.nil?
        user.identities.create(provider: auth.provider, uid: auth.uid)
        user
    end

    def update_token
        update(access_token: TokenService.call)
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

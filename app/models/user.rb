# Represents user object
class User < ApplicationRecord
  include Personable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: %i[facebook github]

  has_many :identities, dependent: :destroy
  has_many :guests, dependent: :destroy

  validates :role, presence: true, inclusion: { in: %w[user translator admin] }

  before_save :send_welcome_email

  def self.find_for_oauth(auth)
    identity = Identity.find_for_oauth(auth)
    return identity.user if identity.present?
    return false if auth.info[:email].nil?
    user = User.find_or_create_by(email: auth.info[:email]) do |u|
      u.password = Devise.friendly_token[0, 20]
      u.confirmed_at = DateTime.now
    end
    user.identities.create(provider: auth.provider, uid: auth.uid)
    user
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

  private def send_welcome_email
    WelcomeLetterJob.perform_later(self) if id.present? && confirmed_at_changed?
  end
end

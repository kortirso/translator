# Perform task processing
class WelcomeLetterJob < ApplicationJob
  queue_as :default

  def perform(user)
    UserMailer.welcome_email(user: user).deliver_later
  end
end

# User Mailer Preview
class UserMailerPreview < ActionMailer::Preview
  def welcome_email_preview
    UserMailer.welcome_email(user: User.first)
  end
end

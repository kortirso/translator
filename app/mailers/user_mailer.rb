# User Mailer
class UserMailer < ApplicationMailer
  def welcome_email(args = {})
    @user = args[:user]
    mail(to: @user.email, subject: 'Message from LangTool')
  end
end

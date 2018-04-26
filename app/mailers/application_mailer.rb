# Default mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'postmaster@langtool.tech'
  layout 'mailer'
end

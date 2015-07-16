class ApplicationMailer < ActionMailer::Base
  default from: "hello@eatsy.com"
  layout 'mailer'
end
